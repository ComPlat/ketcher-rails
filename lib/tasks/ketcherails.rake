# frozen_string_literal: true

module Ketcherails
  # Helper methods for task
  module Task
    def self.copy_icons_files(filename)
      ket_ico = File.join(
        Ketcherails::Engine.root, 'public/images/ketcherails/seeds/icons'
      )
      app_ico = File.join(
        Rails.root, 'public', 'images', 'ketcherails', 'icons'
      )
      %w[icon small original].each do |folder|
        src = File.join(ket_ico, folder, filename)
        dest = File.join(app_ico, folder, filename)
        FileUtils.rm(dest, force: true)
        FileUtils.cp_r(src, dest) if File.exist?(src)
      end
    end

    def self.prepare_icon_folders
      app_ico = File.join(
        Rails.root, 'public', 'images', 'ketcherails', 'icons'
      )
      %w[icon original small].each do |folder|
        f = File.join(app_ico, folder)
        FileUtils.mkdir_p(f) unless Dir.exist?(f)
      end
    end

    def self.copy_sprites_files
      ket_sp = File.join(
        Ketcherails::Engine.root, 'public/images/ketcherails/seeds/sprites'
      )
      app_sp = File.join(Rails.root, 'public', 'images', 'sprites')
      FileUtils.rm_r(app_sp, force: true)
      FileUtils.mkdir_p(app_sp)
      src = File.join(ket_sp, '.')
      dest = File.join(app_sp, '.')
      FileUtils.cp_r(src, dest)
    end

    def self.seed_data_for(table_name)
      file = File.join(Ketcherails::Engine.root, 'db', table_name + '.json')
      seeds = File.exist?(file) && JSON.parse(File.read(file)) || []
      klass = "Ketcherails::#{table_name.classify}".constantize
      klass.skip_callback(:save, :before, :generate_sprites)
      seeds.each do |seed|
        next if seed['icon_file_name'].empty?
        copy_icons_files(seed['icon_file_name'])
        klass.create(seed)
      end
      klass.set_callback(:save, :before, :generate_sprites)
    end
  end
end

namespace :ketcherails do
  namespace :import do
    desc "import default common templates and categories (Warning: this will \
destroy current categories, templates, and sprite classes)"
    task common_templates: :environment do
      if Ketcherails::TemplateCategory.count.positive?
        Ketcherails::TemplateCategory.find_each(&:destroy!)
        Ketcherails::CommonTemplate.find_each(&:destroy!)
      end
      Ketcherails::Task.prepare_icon_folders
      Ketcherails::Task.copy_sprites_files
      %w[template_categories common_templates].each do |table_name|
        Ketcherails::Task.seed_data_for table_name
      end
    end

    desc "import monomers (amino_acids) (Warning: this will \
overwrite entries with similar names - letter codes)"
    task monomers: :environment do
      Ketcherails::Task.prepare_icon_folders
      file = File.join(Ketcherails::Engine.root, 'db', 'amino_acids' + '.json')
      seeds = File.exist?(file) && JSON.parse(File.read(file)) || []
      seeds.each do |seed|
        next if seed['name'].empty? || seed['icon_file_name'].empty?
        Ketcherails::Task.copy_icons_files(seed['icon_file_name'])
        aa = Ketcherails::AminoAcid.find_by(name: seed['name'])
        b = aa&.update!(seed) || Ketcherails::AminoAcid.create!(seed)
        puts "creation of #{seed['name']} #{b && 'successful' || 'failed'}"
      end
    end
  end
end
