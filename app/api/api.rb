require 'grape'
require 'grape-active_model_serializers'

# if defined? API
#   API.class_eval do
#     mount Ketcherails::KetcherAPI
#     mount Ketcherails::CustomTemplatesAPI
#     mount Ketcherails::TemplateCategoriesAPI
#     mount Ketcherails::CommonTemplatesAPI
#     mount Ketcherails::AtomAbbreviationsAPI
#     mount Ketcherails::AminoAcidsAPI
#     # add_swagger_documentation
#   end
# end

class Ketchapi < ::Grape::API
  prefix 'api'
  version 'v1'
  format :json
  formatter :json, Grape::Formatter::ActiveModelSerializers
  helpers do
    def current_user
      @current_user || env['warden']&.user
    end
  end
  mount Ketcherails::KetcherAPI
  mount Ketcherails::CustomTemplatesAPI
  mount Ketcherails::TemplateCategoriesAPI
  mount Ketcherails::CommonTemplatesAPI
  mount Ketcherails::AtomAbbreviationsAPI
  mount Ketcherails::AminoAcidsAPI
end
