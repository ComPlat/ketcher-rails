Rails.application.routes.draw do
  mount Ketcherails::Engine => 'ketcher'
end

Ketcherails::Engine.routes.draw do
  root to: 'ketcher#index'
end
