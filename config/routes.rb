Rails.application.routes.draw do
  mount Ketcherails::Engine => 'ketcher'
  mount Ketchapi => '/'
end

Ketcherails::Engine.routes.draw do
  resources :template_categories
  resources :common_templates
  resources :atom_abbreviations
  resources :amino_acids
  get 'demo', to: 'ketcher#demo'

  root to: 'ketcher#index'
end
