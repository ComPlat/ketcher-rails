API.class_eval do
  mount Ketcherails::KetcherAPI
  mount Ketcherails::CustomTemplatesAPI
  mount Ketcherails::CommonTemplatesAPI
end
