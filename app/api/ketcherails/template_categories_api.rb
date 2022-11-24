module Ketcherails
  class TemplateCategoriesAPI < Grape::API

    namespace :ketcher do
      desc 'Get categories list'
      get :template_categories_list do
        data = Ketcherails::TemplateCategory.with_approved_templates

        present data, with: Entities::TemplateCategoryEntity, categories: :data
      end
    end
  end
end
