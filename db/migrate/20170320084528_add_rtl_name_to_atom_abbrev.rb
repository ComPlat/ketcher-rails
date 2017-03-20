class AddRtlNameToAtomAbbrev < ActiveRecord::Migration
  def change
    add_column :ketcherails_atom_abbreviations, :rtl_name, :string, index: true
  end
end
