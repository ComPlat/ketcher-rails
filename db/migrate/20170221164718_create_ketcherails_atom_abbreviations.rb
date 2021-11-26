class CreateKetcherailsAtomAbbreviations < ActiveRecord::Migration[4.2]
  def change
    create_table :ketcherails_atom_abbreviations do |t|
      t.integer :moderated_by, index: true
      t.integer :suggested_by, index: true
       t.string :name, null: false, index: true
         t.text :molfile, null: false
      t.integer :aid, null: false, default: 1
      t.integer :bid, null: false, default: 1
       t.string :icon_path
       t.string :sprite_class
       t.string :status
         t.text :notes

      t.datetime :approved_at
      t.datetime :rejected_at

      t.timestamps null: false
    end

    add_attachment :ketcherails_atom_abbreviations, :icon
  end
end
