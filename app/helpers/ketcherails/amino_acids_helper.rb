module Ketcherails
  module AminoAcidsHelper
    def status_select form
      status = @amino_acid.status
      opts = options_for_select(AminoAcid::STATUSES, status)

      form.select :status, opts, class: 'form-control'
    end
  end
end
