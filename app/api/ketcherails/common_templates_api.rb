module Ketcherails
  class CommonTemplatesAPI < Grape::API

    namespace :ketcher do
      desc 'Get templates list'
      get :common_templates_list do
        data = Ketcherails::CommonTemplate.approved
        {templates: data.map {|d| CommonTemplateSerializer.new(d)}}
      end

      desc 'Search templates by keyword'
      params do
        requires :query, type: String, desc: 'Template search query'
      end
      get :common_templates_search do
        data = Ketcherails::CommonTemplate
               .where('name ILIKE ?', "%#{params[:query]}%")
        {templates: data.map {|d| CommonTemplateSerializer.new(d)}}
      end
    end
  end
end
