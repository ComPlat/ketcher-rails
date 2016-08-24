class MakeKetcherailsSprites < ActiveJob::Base
  queue_as :default

  def perform

    css = Ketcherails::SPRITES_CSS_FILENAME
    log = SpriteFactory.run!(
      'public/images/ketcherails',
      output_style: "#{Rails.root}/public/stylesheets/#{css}"
    )

    Ketcherails::TemplateCategory.update_all('sprite_class=NULL')

    Ketcherails::TemplateCategory.icon_present.find_each do |cat|
      sprite_class = cat.icon.url[/ketcherails\/(.+)\./, 1]
      sprite_class.gsub!('/', '_')
      sprite_class.gsub!('original', 'small')

      if log.include? "img.#{sprite_class}"
        cat.update_attribute :sprite_class, sprite_class
      end
    end
  end
end
