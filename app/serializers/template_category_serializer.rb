class TemplateCategorySerializer < ActiveModel::Serializer
  root false

  has_many :common_templates

  attributes :id, :name, :icon
end
