Rails.application.routes.draw do
  mount Ketcherails::Engine => 'ketcher'
end

Ketcherails::Engine.routes.draw do
  resources :template_categories
  resources :common_templates
  root to: 'ketcher#index'
end
