Rails.application.routes.draw do
  root 'home#welcome'
  devise_for :users, controllers: { registrations: 'users/registrations'  }

  authenticate :user do
    get 'places/index'
    resources :items, only:[:new, :create, :show, :update]
    resources :orders, only:[:new, :create]
    get 'orders/:id', to: 'items#new', as: 'order'
  end
end
