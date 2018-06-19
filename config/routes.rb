Rails.application.routes.draw do
  devise_for :users
  root 'products#index'
  resources :products, only: [:index, :show, :destroy]
  resources :pianos
  resources :others
  resources :guitars
  resources :drums
  get 'application/logout'
  get 'settings/show'
  patch 'settings/change_avatar'
  patch 'settings/change_password'
  get 'activities/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
