module Ketcherails
  class Engine < ::Rails::Engine
    require 'jquery-ui-rails'
    require 'kaminari'
    require 'bootstrap-kaminari-views'
    require 'paperclip'
    require 'sprite_factory'

    isolate_namespace Ketcherails

    config.to_prepare do
      require_dependency(File.join(Engine.root , "app/api/api.rb"))

      Dir.glob(Engine.root + "app/decorators/**/*_decorator*.rb").each do |c|
        require_dependency(c)
      end
    end

    initializer "ketcherails.assets.precompile" do |app|
      app.config.assets.precompile += %w(ketcherails/ketcher.js ketcherails/ketcher-with-sprites.css ketcherails/sprite.png)
    end

    initializer "static assets" do |app|
      app.middleware.insert_before(::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public")
    end

    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end
  end
end
