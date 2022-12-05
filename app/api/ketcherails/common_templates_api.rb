module Ketcherails
  class CommonTemplatesAPI < Grape::API

    namespace :ketcher do
      desc 'Get templates list'
      get :common_templates_list do
        data = Ketcherails::CommonTemplate.approved.includes(:template_category)

        present data, with: Entities::CommonTemplateEntity, root: :data
      end
    end
  end
end
