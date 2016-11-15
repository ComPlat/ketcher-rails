module Ketcherails
  class CommonTemplatesAPI < Grape::API

    namespace :ketcher do
      desc 'Get templates list'
      get :common_templates_list do
        data = Ketcherails::CommonTemplate.approved.includes(:template_category)
        {templates: data.map {|d| CommonTemplateSerializer.new(d)}}
      end
    end
  end
end
