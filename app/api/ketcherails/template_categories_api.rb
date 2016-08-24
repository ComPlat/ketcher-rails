module Ketcherails
  class TemplateCategoriesAPI < Grape::API

    namespace :ketcher do
      desc 'Get categories list'
      get :template_categories_list do
        data = Ketcherails::TemplateCategory.with_approved_templates

        { categories: data.map {|d| TemplateCategorySerializer.new(d)} }
      end
    end
  end
end
