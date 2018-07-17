Rails.application.routes.draw do
  get 'orders/new'
  get 'orders/create'
  get 'orders/new'
  get 'orders/view'
  get 'orders/new'
  root 'home#welcome'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
