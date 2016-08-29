class CommonTemplateSerializer < ActiveModel::Serializer
  root false

  attributes :molfile, :name, :icon,:sprite_class, :aid, :bid, :category

  def category
    object.template_category.try(:name)
  end

  def aid
    1
  end

  def bid
    1
  end
end
