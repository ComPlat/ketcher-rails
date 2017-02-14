module Ketcherails
  class KetcherAPI < Grape::API

    EXT_PROPS = {
      r_list: 'PolymersList',
      b_bonds: 'BoldBondsList'
    }

    namespace :ketcher do
      desc 'Respond to live-check'
      get 'knocknock' do
          body 'You are welcome!'
      end

      desc 'Align molecule using OpenBabel'
      params do
        requires :moldata, type: String, desc: 'Molecule smiles data'
      end
      post :layout do
        mol_data = params[:moldata]
        init_data = mol_data.lines

        add_props = {}

        EXT_PROPS.each do |name, prop_label_molfile|
          add_props[name.to_s + '_index'] = init_data.index do |line|
            line.match /> <#{prop_label_molfile}>/
          end

          if index = add_props[name.to_s + '_index']
            add_props[name] = init_data[index + 1].split.map(&:to_i)
          end
        end

        c = OpenBabel::OBConversion.new
        opts = OpenBabel::OBConversion::GENOPTIONS
        c.add_option 'gen2D', opts
        c.set_in_format 'mol'
        c.set_out_format 'mol'
        m = OpenBabel::OBMol.new
        c.read_string m, mol_data
        m.do_transformations c.get_options(opts), c

        result = c.write_string(m, false).lines

        t_v2000_index = result.index do |line|
          line.match /V2000/
        end

        end_index = result.index do |line|
          line.match /M\s+END/
        end

        # write additional properties
        if t_v2000_index && end_index
          EXT_PROPS.each do |name, prop_label_molfile|
            if add_props[name] && add_props[name].any?
              if name == :r_list
                add_props[:r_list].each do |line_number|
                  result[t_v2000_index + 1 + line_number].gsub! ' * ', ' R# '
                end
              end

              result.insert end_index + 1, "> <#{EXT_PROPS[name]}>\n"
              result.insert end_index + 2, add_props[name].join(' ') + "\n"
            end
          end
        end

        bonds_table_index = t_v2000_index + result[t_v2000_index].to_i + 1
        # copy initial bonds table
        (bonds_table_index..(end_index - 1)).each do |index|
          result[index] = init_data[index]
        end

        env['api.format'] = :binary

        "Ok.\n" + result.join
      end

      desc 'Stub method to prevent error'
      params do
        requires :smiles, type: String, desc: 'Molecule smiles data'
      end

      get :layout do
        body 'ok'
      end

      desc 'Get molecule name fro PubChem'
      params do
        requires :moldata, type: String, desc: 'Molecule molfile'
      end
      post :info do
        mol = params[:moldata]
        mol_info = Chemotion::PubchemService.molecule_info_from_molfile mol
        {
          iupac_name: mol_info[:iupac_name],
          name: mol_info[:names]
        }
      end
    end
  end
end
