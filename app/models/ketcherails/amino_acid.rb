module Ketcherails
  class AminoAcid < Ketcherails::AtomAbbreviation
    self.table_name = :ketcherails_amino_acids

    validates :name, uniqueness: true

    before_save :set_aid2

    private

    def set_aid2
      lines  = self.molfile.split "\n"
      if idx = lines.index { |i| i.match /> <AttachmentPoint2>/ }
        self.aid2 = lines[idx + 1].to_i
      end
    end
  end
end
