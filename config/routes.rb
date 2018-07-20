Rails.application.routes.draw do
  root 'home#welcome'
  devise_for :users, controllers: { registrations: 'users/registrations'  }

  authenticate :user do
    get 'places/index'
    resources :items, only:[:new, :create]
    resources :orders, only:[:new, :create, :index]
    get 'orders/:id', to: 'items#new', as: 'order'
  end
end
