module Ketcherails
  IMG_SIZE = 64 # 64x64 pixels icon

  class CustomTemplate < ActiveRecord::Base
    belongs_to :user
    before_save :set_name, on: :create

    # we add 1-by-1 on front-end part. so newest item is on the top
    default_scope  { order('created_at DESC') }

    def make_icon svg_file
      processor = Ketcherails::SVGProcessor.new(svg_file,
                                              width: IMG_SIZE, height: IMG_SIZE)

      svg = processor.centered_and_scaled_svg
      img = Svg2pdf.convert_to_img_data(svg, :png)
      digest = Digest::SHA256.hexdigest(SecureRandom.hex(16))
      filename = digest + '.png'
      svg_file_path = "public/images/templates/#{filename}"
      img.write_to_png(svg_file_path)
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
