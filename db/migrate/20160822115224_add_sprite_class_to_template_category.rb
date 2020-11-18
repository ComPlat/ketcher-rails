class AddSpriteClassToTemplateCategory < ActiveRecord::Migration[4.2]
  def change
    add_column :ketcherails_template_categories, :sprite_class, :string
  end
end
