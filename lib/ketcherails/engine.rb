module Ketcherails
  class Engine < ::Rails::Engine
    isolate_namespace Ketcherails

    config.to_prepare do
      require_dependency(File.join(Engine.root , "app/api/api.rb"))
    end

    initializer "ketcherails.assets.precompile" do |app|
      app.config.assets.precompile += %w(ketcherails/ketcher.js ketcherails/ketcher-with-sprites.css ketcherails/sprite.png)
    end
  end
end
