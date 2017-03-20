module Ketcherails
  class AtomAbbreviationsAPI < Grape::API

    namespace :ketcher do
      desc 'Get atom abbreviation by name'
      params do
        requires :name, type: String, desc: 'Atom abbreviation unique name'
      end
      get :atom_abbreviation do
        @atom_abbeviation = AtomAbbreviation.approved.find_by(name: params[:name])
      end

      desc 'Reverse atom abbrev'
      params do
        requires :name, type: String, desc: 'Atom abbreviation unique name'
      end
      get :rtl_superatom do
        @atom_abbeviation = AtomAbbreviation.approved.find_by(name: params[:name])
        { name: @atom_abbeviation.rtl_name }
      end
    end
  end
end
