# frozen_string_literal: true

module Entities
  class CommonTemplateEntity < Grape::Entity
    expose(
      :molfile, :name, :sprite_class, :aid, :bid, :category, :template_category_id
    )

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
end
