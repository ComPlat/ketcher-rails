class MakeKetcherailsSprites < ApplicationJob
  queue_as :default

  SPRITES_PATH = "#{Rails.root}/public/images/sprites/"

  unless Dir.exists? SPRITES_PATH
    FileUtils.mkdir_p SPRITES_PATH
  end

  def perform
    css = Ketcherails::SPRITES_CSS_FILENAME
    log = SpriteFactory.run!(
      'public/images/ketcherails',
      output_style: "#{SPRITES_PATH}#{css}",
      output_image: "#{SPRITES_PATH}ketcherails.png",
      margin: 1,
      layout: :packed,
      nocomments: true,
      library: :image_magick
    )


    klasses = [Ketcherails::TemplateCategory, Ketcherails::CommonTemplate]
    klasses.each do |klass|
      klass.update_all('sprite_class=NULL')
      klass.icon_present.find_each do |item|
        sprite_class = item.icon.url[/ketcherails\/(.+)\./, 1]
        sprite_class.gsub!('/', '_')
        sprite_class.gsub!('original', 'small')

        if log.include? "img.#{sprite_class}"
          item.update_column :sprite_class, sprite_class
        end
      end
    end
  end
end
