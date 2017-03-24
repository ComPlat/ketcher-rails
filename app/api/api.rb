API.class_eval do
  mount Ketcherails::KetcherAPI
  mount Ketcherails::CustomTemplatesAPI
  mount Ketcherails::TemplateCategoriesAPI
  mount Ketcherails::CommonTemplatesAPI
  mount Ketcherails::AtomAbbreviationsAPI
  mount Ketcherails::AminoAcidsAPI
end
