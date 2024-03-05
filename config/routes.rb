# frozen_string_literal: true
Rails.application.routes.draw do
  resources :products
  devise_for :users
  root 'products#index'

  get '/carts/:id', to: 'carts#show', as: 'carts'
end
