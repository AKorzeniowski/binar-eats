Rails.application.routes.draw do
  get 'orders/new'
  get 'orders/create'
  get 'orders/:id', to: 'suborders#new', as: 'order'
  # resources :suborders
  # get 'suborders/new'
  # get 'suborders/create'
  root 'home#welcome'
  devise_for :users, controllers: { registrations: 'users/registrations'  }
end
