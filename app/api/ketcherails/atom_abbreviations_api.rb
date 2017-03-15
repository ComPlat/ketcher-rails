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
    end
  end
end
