module Ketcherails
  class CommonTemplate < ActiveRecord::Base

    include Ketcherails::Iconed

    IMG_SIZE = 64 # 64x64 pixels icon
    STATUSES = %w(pending approved rejected)

    has_icon small: '64x64', icon:'32x32'

    belongs_to :suggestor, foreign_key: :suggested_by, class_name: 'User'
    belongs_to :approver,  foreign_key: :moderated_by, class_name: 'User'
    belongs_to :template_category, touch: true

    scope :approved, -> { where(status: 'approved') }
    scope :pending, -> { where(status: 'pending') }
    scope :rejected, -> { where(status: 'rejected') }

    before_save :set_name, :get_icon
    after_save :convert_grayscale

    def category_name
      self.template_category.try :name
    end

    def get_icon svg = nil
      if !self.molfile_changed? || self.icon_file_name_changed?
        return true
      end

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
      img_path = 'public/images/templates/'
      svg_file = Tempfile.new(['image', '.svg'])
      File.open(svg_file.path, 'w') { |file| file.write(svg) }
      digest = Digest::SHA256.hexdigest(SecureRandom.hex(16))
      filename = digest + '.png'
      result_file_path = img_path + filename
      system "inkscape --export-text-to-path --without-gui --file=#{svg_file.path} --export-png=#{result_file_path} --export-width=60 --export-height=60"
      self.icon = File.open(result_file_path)
    end

    private

    def set_name
      if self.name.blank?
        name_from_file = self.molfile.lines[0]
        if name_from_file.present?
          self.name = name_from_file.strip
        else
          self.name = Ketcherails::OpenBabelService.get_formula self.molfile
        end
      end
    end

    def convert_grayscale
      %i(icon small).each do |style|
        path = self.icon.path(style)
        system "convert #{path} -fx '(r+g+b)/3' #{path}"
      end
    end
  end
end
