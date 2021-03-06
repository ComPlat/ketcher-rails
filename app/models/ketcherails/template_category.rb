module Ketcherails
  class TemplateCategory < ActiveRecord::Base

    has_many :common_templates

    include Ketcherails::Iconed

    has_icon small: '32x32' # has 32x32px icon

    default_scope  { order('ketcherails_template_categories.name ASC') }

    scope :with_approved_templates, -> {
      self.joins(:common_templates)
          .where("ketcherails_common_templates.status = 'approved'")
          .select('ketcherails_template_categories.*')
          .group('ketcherails_template_categories.id')
          .having('count(ketcherails_common_templates.id) >= 0')
    }

    scope :icon_present, -> { where("icon_file_name IS NOT NULL") }

    validates :name, presence: true
  end
end
