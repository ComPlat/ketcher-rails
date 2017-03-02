Rails.application.routes.draw do
  mount Ketcherails::Engine => 'ketcher'
end

Ketcherails::Engine.routes.draw do
  resources :template_categories
  resources :common_templates
  resources :atom_abbreviations
  root to: 'ketcher#index'
end
