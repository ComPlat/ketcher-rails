module Ketcherails
  class AminoAcidsAPI < Grape::API

    namespace :ketcher do
      desc 'Build amino acids chain'
      params do
        requires :sequence_name, type: String, desc: 'Sequence name'
        requires :reversed, type: Boolean, desc: 'Is sequence reversed'
      end

      post :amino_acid do
        sequence_name = params[:sequence_name]
        sequence = []
        sequence_name.split('-').each do |item|
          sequence << Ketcherails::AminoAcid.approved.find_by!(name: item.strip)
        end
        molfile = Ketcherails::Molfile.merge_molfiles sequence, params[:reversed]
        aid = params[:reversed] ? sequence[0].aid : sequence[0].aid2
        { molfile: molfile, bid: 1, aid: aid}
      end
    end
  end
end
