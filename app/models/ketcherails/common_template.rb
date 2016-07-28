module Ketcherails
  class CommonTemplate < ActiveRecord::Base

    IMG_SIZE = 64 # 64x64 pixels icon

    belongs_to :suggestor, foreign_key: :suggested_by, class_name: 'User'
    belongs_to :approver,  foreign_key: :moderated_by, class_name: 'User'
    belongs_to :template_category

    # we add 1-by-1 on front-end part. so newest item is on the top
    default_scope { order('created_at DESC') }
    scope :approved, -> { where('approved_at IS NOT NULL') }
    scope :pending, -> { where('approved_at IS NOT NULL') }
    scope :pending, -> { where('rejected_at IS NOT NULL') }

    before_save :set_name, :get_icon

    #TODO: enable this validation
    # validate :icon_path, presence: true

    def status
      if rejected_at.present?
        'rejected'
      elsif approved_at.present?
        'approved'
      else
        'pending'
      end
    end

    def get_icon svg = nil
      return true if self.icon_path.present?
      process = svg.present?

      svg ||= Ketcherails::OpenBabelService.svg_from_molfile self.molfile

      self.make_icon svg, process
    end

    def make_icon svg, process = true
      if process
        processor = Ketcherails::SVGProcessor.new(svg,
                                              width: IMG_SIZE, height: IMG_SIZE)

        svg = processor.centered_and_scaled_svg
      end

      img = Svg2pdf.convert_to_img_data(svg, :png)
      digest = Digest::SHA256.hexdigest(SecureRandom.hex(16))
      filename = "templates/#{digest}.png"
      svg_file_path = "public/images/#{filename}"
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
