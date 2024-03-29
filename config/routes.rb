# frozen_string_literal: true
Rails.application.routes.draw do
  resources :products
  devise_for :users
  root 'products#index'

  get '/carts/:id', to: 'carts#show', as: 'carts'

  post 'line_items_by_now/:product_id', to: 'line_items#buy_now', as: 'line_item_by_now'
  post 'line_items_add_to_cart/:product_id', to: 'line_items#add_to_cart', as: 'line_item_add_to_cart'
  post 'line_items_add_quantity/:product_id', to: 'line_items#add_quantity', as: 'line_item_add_quantity'
  post 'line_items_subtract_quantity/:product_id', to: 'line_items#subtract_quantity', as: 'line_item_subtract_quantity'
  get 'add_product_from_index/:product_id', to: 'line_items#add_product_from_index', as: 'add_product_from_index'
  post 'line_items_add_to_cart_from_index/:product_id', to: 'line_items#add_to_cart_from_index', as: 'line_item_add_to_cart_from_index'


  get 'customer_address', to: 'customers#customer_address', as: 'customer_address'
  get 'customer_address_turbo', to: 'customers#customer_address_turbo', as: 'customer_address_turbo'

  post '/order', to: 'orders#order', as: 'order'
  get '/success', to: 'orders#success', as: 'success'
  get '/orders', to: 'orders#index', as: 'orders'
  get '/order/:order_id', to: 'orders#show', as: 'order_show'


  post 'customer_address_update', to: 'customers#customer_address_update', as: 'customer_address_update'

  delete 'line_item_delete_from_cart/:product_id', to: 'line_items#destroy_from_cart', as: 'destroy_from_cart'
end
