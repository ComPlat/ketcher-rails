module Ketcherails
  class TemplateCategory < ActiveRecord::Base

    has_many :common_templates

    has_attached_file :icon, styles: { small: "32x32#" },
                      url: 'ketcherails/:attachment/:style/:basename.:extension',
                      path: ':rails_root/public/images/ketcherails/:attachment/:style/:basename.:extension',
                      default_url: "/images/:style/missing.png"

    scope :with_templates, -> {
      self.joins(:common_templates)
          .select('ketcherails_template_categories.*')
          .group('ketcherails_template_categories.id')
          .having('count(ketcherails_common_templates.id) >= 0')
    }

    validates :name, presence: true
    validates_attachment_content_type :icon, content_type: /\Aimage\/.*\Z/
  end
end
