module Ketcherails
  module AtomAbbreviationsHelper
    def status_select form
      status = @atom_abbreviation.status
      opts = options_for_select(AtomAbbreviation::STATUSES, status)

      form.select :status, opts, class: 'form-control'
    end
  end
end
