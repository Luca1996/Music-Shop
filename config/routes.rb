Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  root 'products#index'
  delete 'line_items/destroy_all/:id', to:'line_items#destroy_all', as: :line_items_destroy
  resources :line_items, only: [:index, :show, :create, :destroy]
  resources :carts, only: [:index, :show, :destroy]
  get 'products/grid'
  post 'products_search_path', to:'products#search', as: :products_search
  resources :products, only: [:index, :show, :destroy] do
    resources :comments, except: [:index,:show]
  end 
  resources :pianos
  resources :others
  resources :guitars
  resources :drums
  resources :headphones
  resources :orders
  get 'application/logout'
  get 'settings/show'
  patch 'settings/change_avatar'
  patch 'settings/change_password'
  patch 'settings/change_mail'
  get 'activities/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
