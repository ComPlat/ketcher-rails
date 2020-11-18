class AddRtlNameToAtomAbbrev < ActiveRecord::Migration[4.2]
  def change
    add_column :ketcherails_atom_abbreviations, :rtl_name, :string, index: true
  end
end
