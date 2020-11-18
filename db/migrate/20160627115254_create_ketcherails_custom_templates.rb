class CreateKetcherailsCustomTemplates < ActiveRecord::Migration[4.2]
  def change
    create_table :ketcherails_custom_templates do |t|
      t.integer :user_id, null: false, index: true

      t.string :name, null: false
      t.text :molfile, null: false
      t.string :icon_path
      t.string :sprite_class

      t.timestamps
    end
  end
end
