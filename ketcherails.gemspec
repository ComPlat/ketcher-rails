# frozen_string_literal: true

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

  s.add_dependency "rails", "~> 6.1.7"
  s.add_dependency "jquery-rails"
  s.add_dependency "nokogiri", ">= 1.10", "< 2"
  s.add_dependency "haml-rails"
  s.add_dependency "jquery-ui-rails", "~> 5.0.5"
  s.add_dependency 'kaminari'
  s.add_dependency 'bootstrap-kaminari-views', '0.0.5'
  s.add_dependency 'sprite-factory', '1.7.1'
  s.add_dependency 'httparty'
  s.add_dependency 'bootstrap-sass'
  s.add_dependency 'delayed_job_active_record'
  s.add_dependency 'daemons'
  s.add_dependency 'grape', '< 2.0'
  s.add_dependency 'grape-active_model_serializers', '~> 1.3.2'
  s.add_dependency 'active_model_serializers', '< 0.10.0'
  s.add_dependency 'openbabel'
  s.add_dependency 'mimemagic', '>= 0.3.10'
  s.add_dependency 'inchi-gem'


  # s.add_dependency 'openbabel', '~> 2.4.90.1'#, git: 'https://github.com/ComPlat/openbabel-gem'
  # s.add_dependency  'grape', '< 1.0.0'


  s.add_development_dependency "pg"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "grape"
  s.add_development_dependency "grape-swagger"
  s.add_development_dependency "byebug"
  s.add_development_dependency "rspec"
  s.add_development_dependency 'bootstrap-generators', '~> 3.3.4'
  s.add_development_dependency 'bootstrap-sass'
end
