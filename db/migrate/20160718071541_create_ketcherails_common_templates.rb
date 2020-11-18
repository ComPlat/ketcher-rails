class CreateKetcherailsCommonTemplates < ActiveRecord::Migration[4.2]
  def change
    create_table :ketcherails_common_templates do |t|
       t.integer :moderated_by, index: true
       t.integer :suggested_by, index: true
        t.string :name, null: false, index: true
          t.text :molfile, null: false
        t.string :icon_path
        t.string :sprite_class
        t.text :notes

      t.datetime :approved_at
      t.datetime :rejected_at

      t.timestamps
    end

#    add_column :users, :is_templates_moderator, :boolean, null: false, default: false if table_exists? :users
  end
end
