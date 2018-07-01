module Ketcherails
  module Iconed
    extend ActiveSupport::Concern

    included do

      scope :icon_present, -> { where("icon_file_name IS NOT NULL") }
      before_save :generate_sprites

      def generate_sprites
        if self.icon_updated_at_changed?
          self.sprite_class = nil
          # Delayed::Job.enqueue(MakeKetcherailsSprites.new)
          MakeKetcherailsSprites.perform_later
        end
      end
    end

    class_methods do
      def has_icon styles
        has_attached_file :icon, styles: styles,
        url: 'ketcherails/:attachment/:style/:basename.:extension',
        path: ':rails_root/public/images/ketcherails/:attachment/:style/:basename.:extension',
        default_url: "/images/transparent.png"

        validates_attachment_content_type :icon, content_type: /\Aimage\/.*\Z/
      end
    end
  end
end
