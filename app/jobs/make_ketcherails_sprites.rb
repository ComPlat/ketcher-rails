class MakeKetcherailsSprites < ActiveJob::Base
  queue_as :default

  def perform

    css = Ketcherails::SPRITES_CSS_FILENAME
    log = SpriteFactory.run!(
      'public/images/ketcherails',
      output_style: "#{Rails.root}/public/stylesheets/#{css}",
      output_image: "#{Rails.root}/public/stylesheets/ketcherails.png",
      margin: 1,
      layout: :packed
    )


    klasses = [Ketcherails::TemplateCategory, Ketcherails::CommonTemplate]
    klasses.each do |klass|
      klass.update_all('sprite_class=NULL')
      klass.icon_present.find_each do |item|
        sprite_class = item.icon.url[/ketcherails\/(.+)\./, 1]
        sprite_class.gsub!('/', '_')
        sprite_class.gsub!('original', 'small')

        if log.include? "img.#{sprite_class}"
          item.update_attribute :sprite_class, sprite_class
        end
      end
    end
  end
end
