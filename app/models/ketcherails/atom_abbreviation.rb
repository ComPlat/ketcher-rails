module Ketcherails
  class AtomAbbreviation < Ketcherails::CommonTemplate
    self.table_name = :ketcherails_atom_abbreviations

    before_save :set_aid

    private

    def set_aid
      lines  = self.molfile.split "\n"
      if idx = lines.index { |i| i.match /> <AttachmentPoint>/ }
        self.aid = lines[idx + 1].to_i
      end
    end
  end
end
