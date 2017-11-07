# frozen_string_literal: true

# delete all previous entries
if Ketcherails::TemplateCategory.count.positive?
  Ketcherails::TemplateCategory.find_each(&:destroy!)
  Ketcherails::CommonTemplate.find_each(&:destroy!)
end

# prepare dirs, copy files
ket_ico = File.join(
  Ketcherails::Engine.root, 'public', 'images', 'ketcherails', 'seeds', 'icons'
)
app_ico = File.join(
  Rails.root, 'public', 'images', 'ketcherails', 'icons'
)
FileUtils.mkdir_p(app_ico) unless Dir.exist?(app_ico)
src = File.join(ket_ico, '.')
dest = File.join(app_ico, '.')
FileUtils.cp_r(src, dest)

ket_sp = File.join(
  Ketcherails::Engine.root, 'public/images/ketcherails/seeds/sprites'
)
app_sp = File.join(Rails.root, 'public', 'images', 'sprites')
FileUtils.rm_r(app_sp)
FileUtils.mkdir_p(app_sp)
src = File.join(ket_sp, '.')
dest = File.join(app_sp, '.')
FileUtils.cp_r(src, dest)

# create db entries
def seed_data_for(table_name)
  file = File.join(Ketcherails::Engine.root, 'db', table_name + '.json')
  seeds = File.exist?(file) && JSON.parse(File.read(file)) || []
  klass = "Ketcherails::#{table_name.classify}".constantize
  klass.skip_callback(:save, :before, :generate_sprites)
  seeds.each do |seed|
    klass.create(seed)
  end
  klass.set_callback(:save, :before, :generate_sprites)
end

%w[template_categories common_templates amino_acids].each do |table_name|
  seed_data_for table_name
end
