module Ketcherails

  class CustomTemplate < ActiveRecord::Base
    belongs_to :user
    before_save :set_name, on: :create

    IMG_PATH = 'public/images/templates/'
    unless Dir.exists?(Rails.root + IMG_PATH)
      Dir.mkdir(Rails.root + IMG_PATH)
    end

    # we add 1-by-1 on front-end part. so newest item is on the top
    default_scope  { order('created_at DESC') }

    def make_icon svg_file
      processor = Ketcherails::SVGProcessor.new(svg_file)

      svg = processor.centered_and_scaled_svg
      img = Svg2pdf.convert_to_img_data(svg, :png)
      digest = Digest::SHA256.hexdigest(SecureRandom.hex(16))
      filename = digest + '.png'
      svg_file_path = IMG_PATH + filename
      img.write_to_png(svg_file_path)

      if self.icon_path.present? # delete old icon file
        old_png = "public/images/templates/#{self.icon_path}"
        File.rm old_png if File.exists? old_png
      end
      self.icon_path = filename
    end

  private

    def set_name
      if self.name.blank?
        self.name = Ketcherails::OpenBabelService.get_formula self.molfile
      end
    end
  end
end
