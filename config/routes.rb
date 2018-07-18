Rails.application.routes.draw do
  get 'orders/new'
  get 'orders/create'
  root 'home#welcome'
  devise_for :users, controllers: { registrations: 'users/registrations'  }
end
