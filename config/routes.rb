Rails.application.routes.draw do
  get 'places/index'
  root 'home#welcome'
  devise_for :users, controllers: { registrations: 'users/registrations'  }
end
