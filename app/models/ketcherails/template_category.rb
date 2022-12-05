module Ketcherails
  class TemplateCategory < ActiveRecord::Base

    has_many :common_templates

    default_scope  { order('ketcherails_template_categories.name ASC') }

    scope :with_approved_templates, -> {
      self.joins(:common_templates)
          .where("ketcherails_common_templates.status = 'approved'")
          .select('ketcherails_template_categories.*')
          .group('ketcherails_template_categories.id')
          .having('count(ketcherails_common_templates.id) >= 0')
    }

    scope :icon_present, -> { where("icon_file_name IS NOT NULL") }

    validates :name, presence: true

    def make_icon svg_file
      processor = Ketcherails::SVGProcessor.new(svg_file,
                                                width: IMG_SIZE, height: IMG_SIZE)

      svg = processor.centered_and_scaled_svg
      svg_file = Tempfile.new(['image', '.svg'])
      File.open(svg_file.path, 'w') { |file| file.write(svg) }
      digest = Digest::SHA256.hexdigest(SecureRandom.hex(16))
      filename = digest + '.png'
      result_file_path = IMG_PATH + filename
      system "inkscape --export-text-to-path --without-gui --file=#{svg_file.path} --export-png=#{result_file_path} --export-width=60 --export-height=60"

      if self.icon_path.present? # delete old icon file
        old_png = "public/images/templates/#{self.icon_path}"
        File.rm old_png if File.exists? old_png
      end
      self.icon_path = filename
      self.icon_file_name = result_file_path
    end
  end
end
