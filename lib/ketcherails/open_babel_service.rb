module Ketcherails::OpenBabelService

  def self.get_formula molfile

    molfile = self.skip_residues molfile if molfile.include? ' R# '

    c = OpenBabel::OBConversion.new
    c.set_in_format 'mol'

    m = OpenBabel::OBMol.new
    c.read_string m, molfile

    m.get_formula
  end

  def self.svg_from_molfile molfile, options={}
    c = OpenBabel::OBConversion.new
    c.set_in_format 'mol'
    c.set_out_format 'svg'

    unless options[:highlight].blank?
      c.add_option 's', OpenBabel::OBConversion::GENOPTIONS, "#{options[:highlight]} green"
    end
    c.set_options 'd u', OpenBabel::OBConversion::OUTOPTIONS

    m = OpenBabel::OBMol.new
    c.read_string m, molfile

    c.write_string(m, false)
  end

private

  def self.skip_residues molfile
    molfile.gsub! /(M.+RGP[\d ]+)/, ''
    molfile.gsub! /(> <PolymersList>[\W\w.\n]+[\d]+)/m, ''

    lines = molfile.split "\n"

    lines[4..-1].each do |line|
      break if line.match /(M.+END+)/

      line.gsub! ' R# ', ' H  ' # replace residues with Hydrogens
    end

    lines.join "\n"
  end
end
