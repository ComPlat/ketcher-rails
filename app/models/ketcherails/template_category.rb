module Ketcherails
  class TemplateCategory < ActiveRecord::Base

    has_many :common_templates

    validates :name, presence: true
  end
end
