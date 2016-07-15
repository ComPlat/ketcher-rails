class CustomTemplateSerializer < ActiveModel::Serializer
  root false

  attributes :id, :molfile, :name, :icon_path, :sprite_class, :aid, :bid

  def aid
    1
  end

  def bid
    1
  end
end
