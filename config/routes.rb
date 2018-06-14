Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  root 'products#index'
  resources :products 
  get 'application/logout'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
