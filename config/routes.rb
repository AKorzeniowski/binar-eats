Rails.application.routes.draw do
  root 'home#welcome'
  devise_for :users, controllers: { registrations: 'users/registrations'  }

  authenticate :user do
    resources :places#,only:[:index, :create, :edit, :update, :delete]
    resources :items, only:[:new, :create]
    resources :orders, only:[:new, :create]
    get 'orders/:id', to: 'items#new', as: 'order'
  end

end
