module Ketcherails::Molfile

  def self.merge_molfiles molfiles, reversed = false
    bonds = []
    atoms = []
    atom_number_shift = 0
    chain_end = 0
    molfiles.each_with_index do |record, index|
      molfile = record.molfile.lines
      atoms_count = molfile[3].to_i
      atoms_count.times do |shift|
        atoms << molfile[4 + shift]
      end
      bonds_count = molfile[3].split(' ')[1].to_i
      bonds_count.times.each do |shift|
        line = molfile[4  + atoms_count + shift].split(' ')
        line[0] = line[0].to_i + atom_number_shift # shift atom numbers
        line[1] = line[1].to_i + atom_number_shift # shift atom numbers
        bonds << line
      end
      if reversed
        if index > 0
          if index > 0
            line = [chain_end, record.aid2 + atom_number_shift + 1, 1, 0, 0, 0]
            bonds << line
          end
        end
        chain_end = record.aid + atom_number_shift + 1
      else
        if index > 0
          line = [chain_end, record.aid + atom_number_shift + 1, 1, 0, 0, 0]
          bonds << line
        end
        chain_end = record.aid2 + atom_number_shift + 1
      end
      atom_number_shift += atoms_count
    end
    aid = reversed ? molfiles[0].aid2 : molfiles[0].aid

    result_lines = molfiles[0].molfile.lines[0..2]

    desc_line = molfiles[0].molfile.lines[3]
    counts = "% 3d% 3d" % [atoms.size, bonds.size]
    desc_line[0..5] = counts
    result_lines << desc_line

    result_lines += atoms
    result_lines += bonds.map do |bond_line|
      ("% 3d% 3d% 3d% 3d   % 3d% 3d" % bond_line)+ "\r\n"
    end
    result_lines << "M END\r\n"
    result_lines << "$$$$\r\n"

    c = OpenBabel::OBConversion.new
    opts = OpenBabel::OBConversion::GENOPTIONS
    c.add_option 'gen2D', opts
    c.set_in_format 'mol'
    c.set_out_format 'mol'
    m = OpenBabel::OBMol.new
    c.read_string m, result_lines.join
    m.do_transformations c.get_options(opts), c

    result = c.write_string(m, false)
    result
  end
end
