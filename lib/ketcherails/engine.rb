module Ketcherails
  class Engine < ::Rails::Engine
    require 'jquery-ui-rails'
    require 'bootstrap-sass'
    require 'kaminari'
    require 'bootstrap-kaminari-views'
    require 'paperclip'
    require 'sprite_factory'
    require 'haml-rails'
    require 'delayed_job'
    require 'delayed_job_active_record'

    isolate_namespace Ketcherails

    config.to_prepare do
      require_dependency(File.join(Engine.root, 'app', 'api', 'ketchapi.rb'))

      Dir.glob(Engine.root + "app/decorators/**/*_decorator*.rb").each do |c|
        require_dependency(c)
      end
    end

    initializer "ketcherails.assets.precompile" do |app|
      app.config.assets.precompile += %w(
        transparent.png
        ketcherails/application.css
        ketcherails/application.js
        ketcherails/ketcher.js
        ketcherails/ketcher-with-sprites.css
        ketcherails/sprite.png
      )
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
