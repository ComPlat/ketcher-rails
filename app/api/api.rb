API.class_eval do
  mount Ketcherails::KetcherAPI
  mount Ketcherails::CustomTemplatesAPI
  mount Ketcherails::TemplateCategoriesAPI
  mount Ketcherails::CommonTemplatesAPI
end
