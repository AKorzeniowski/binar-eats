Rails.application.routes.draw do
  root 'home#welcome'
  devise_for :users, controllers: { registrations: 'users/registrations'  }

  authenticate :user do
    get 'places/index'
    get 'orders/:id', to: 'items#new', as: 'order'
    resources :items, only:[:new, :create]
    resources :orders, only:[:new, :create]
  end
end
