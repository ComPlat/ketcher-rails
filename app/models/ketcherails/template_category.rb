module Ketcherails
  class TemplateCategory < ActiveRecord::Base

    has_many :common_templates

    has_attached_file :icon, styles: { small: "32x32#" },
                      default_url: "/images/:style/missing.png"

    validates :name, presence: true
    validates_attachment_content_type :icon, content_type: /\Aimage\/.*\Z/
  end
end
