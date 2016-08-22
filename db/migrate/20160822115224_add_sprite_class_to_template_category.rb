class AddSpriteClassToTemplateCategory < ActiveRecord::Migration
  def change
    add_column :ketcherails_template_categories, :sprite_class, :string
  end
end
