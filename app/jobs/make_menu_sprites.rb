class MakeMenuSprites < ApplicationJob
  queue_as :default

  def perform
    asset_path = File.dirname(__FILE__) + '/../assets/'
    SpriteFactory.run!(
      asset_path + 'javascripts/ketcherails/icons/png',
      output_style: asset_path + 'stylesheets/ketcherails/ketcher-sprites.css',
      output_image: asset_path + 'images/ketcherails/sprite.png',
      margin: 1,
      layout: :packed,
      nocomments: true,
      library: :image_magick
    )
  end
end
