$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ketcherails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ketcherails"
  s.version     = Ketcherails::VERSION
  s.authors     = ["ComPlat research group, Karlsruhe Institute of Technology, Germany"]
  s.email       = ["serhii.kotov@kit.edu"]
  s.homepage    = "http://www.complat.kit.edu/"
  s.summary     = "Ketcher structure editor for Rails"
  s.description = "Gem provides the possibility to use Ketcher editor with Rails and contains server actions implementations"
  s.license     = 'GPLv3'

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE.txt", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.2.0"
  s.add_dependency "nokogiri", "1.6.7.2"
  s.add_dependency "haml-rails", "0.9.0"
  s.add_dependency "jquery-ui-rails", "5.0.5"
  s.add_dependency 'kaminari'
  s.add_dependency 'bootstrap-kaminari-views'
  s.add_dependency 'paperclip', '~> 5.0.0'
  s.add_dependency 'sprite-factory'

  s.add_development_dependency "pg"
  s.add_development_dependency "grape"
  s.add_development_dependency "byebug"
  s.add_development_dependency "rspec"
  s.add_development_dependency 'bootstrap-generators', '~> 3.3.4'
  s.add_development_dependency 'bootstrap-sass', '~> 3.3.5'
end
