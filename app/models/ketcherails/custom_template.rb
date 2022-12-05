module Ketcherails

  class CustomTemplate < ActiveRecord::Base
    belongs_to :user
    before_create :set_name

    IMG_PATH = 'public/images/templates/'
    IMG_SIZE = 64 # 64x64 pixels icon
    unless Dir.exists?(Rails.root + IMG_PATH)
      FileUtils.mkdir_p(Rails.root + IMG_PATH)
    end

    # we add 1-by-1 on front-end part. so newest item is on the top
    default_scope  { order('created_at DESC') }

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
      self.icon_file_name = filename
    end

  private

    def set_name
      if self.name.blank?
        self.name = Ketcherails::OpenBabelService.get_formula self.molfile
      end
    end
  end
end
