Rails.application.routes.draw do
  get 'places/index'
  get 'orders/new'
  get 'orders/create'
  get 'orders/:id', to: 'items#new', as: 'order'
  # resources :items
  # get 'items/new'
  # get 'items/create'
  root 'home#welcome'
  devise_for :users, controllers: { registrations: 'users/registrations'  }
end
