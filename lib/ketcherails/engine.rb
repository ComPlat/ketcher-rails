module Ketcherails
  class Engine < ::Rails::Engine
    isolate_namespace Ketcherails

    config.to_prepare do
      require_dependency(File.join(Engine.root , "app/api/api.rb"))
    end

    config.to_prepare do
      Dir.glob(Rails.root + "app/decorators/**/*_decorator*.rb").each do |c|
        require_dependency(c)
      end
    end

    initializer "ketcherails.assets.precompile" do |app|
      app.config.assets.precompile += %w(ketcherails/ketcher.js ketcherails/ketcher-with-sprites.css ketcherails/sprite.png)
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
