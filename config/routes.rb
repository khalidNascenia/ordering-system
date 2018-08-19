Rails.application.routes.draw do
  devise_for :users
  resource :cart, only: [:show]
  resources :order_items, only: [:create, :update, :destroy]
  get 'products/index'

  post '/place_order' => 'carts#place_order'

  get '/my_orders' => 'carts#my_orders'

  get '/upload_edi' => 'products#upload_edi'

  post '/process_edi' => 'products#process_edi'
  
  root 'products#index'
end
