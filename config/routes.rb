Rails.application.routes.draw do
  root 'home#welcome'
  devise_for :users, controllers: { registrations: 'users/registrations'  }

  authenticate :user do

    get 'places/index'
    resources :places
    resources :items, only:[:new, :create, :show, :update, :destroy]
    resources :orders, only:[:new, :create, :index, :edit, :update]
    get 'orders/:id', to: 'items#new'
    get 'order/:id/items', to: 'orders#items'


  end

end
