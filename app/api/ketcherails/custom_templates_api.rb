module Ketcherails
  class CustomTemplatesAPI < Grape::API

    namespace :ketcher do
      desc 'Save structure as a custom template'
      params do
        requires :molfile, type: String, desc: 'Structure molfile'
        requires :svg_file, type: String, desc: 'Structure SVG image'
        optional :name, type: String, desc: 'Template name'
      end

      post :template do
        template = Ketcherails::CustomTemplate.new molfile: params[:molfile]
        template.user = current_user
        template.name = params[:name]
        template.make_icon params[:svg_file]
        template.save!

        template
      end

      desc 'Get templates list'
      get :templates_list do
        data = Ketcherails::CustomTemplate.where(user: current_user)

        present data, with: Entities::CustomTemplateEntity, templates: :data
      end

      desc 'Search templates by keyword'
      params do
        requires :query, type: String, desc: 'Template search query'
      end
      get :templates_search do
        data = Ketcherails::CustomTemplate.where(user: current_user)
               .where('name ILIKE ?', "%#{params[:query]}%")
        {templates: data.map {|d| CustomTemplateSerializer.new(d)}}
      end

      desc 'Delete a template'
      params do
        requires :id, type: Integer
      end
      delete :template do
        item = Ketcherails::CustomTemplate.where(user: current_user)
                .find(params[:id])
        item.destroy!
      end
    end
  end
end
