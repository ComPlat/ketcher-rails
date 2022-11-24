# frozen_string_literal: true

class TemplateCategoryEntity < Grape::Entity
  root false

  has_many :common_templates

  attributes :id, :name, :icon
end
