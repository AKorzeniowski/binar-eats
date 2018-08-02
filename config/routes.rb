Rails.application.routes.draw do
  namespace :admin do
    root to: 'places#index'
    resources :places
    resources :orders
    resources :users
  end
  root 'home#welcome'
  devise_for :users, controllers: { registrations: 'users/registrations'  }

  authenticate :user do

    get 'places/index'
    resources :places
    resources :items, only:[:new, :create, :show, :update, :destroy]
    resources :orders, only:[:new, :create, :index, :edit, :update, :destroy]
    get 'orders/:id/payment/' => 'orders#payment', as: 'orders_payment'
    get 'orders/:id', to: 'items#new'
    get 'order/:id/items', to: 'orders#items', as: 'order_items'
    get 'order/done', to: 'orders#done'
    post 'order/:id/send_payoff', to: 'orders#send_payoff', as: 'orders_payoff'
    get 'items/:id/payoff', to: 'items#payoff', as: 'item_payoff'
    post 'items/:id/payoff_confirm', to: 'items#payoff_confirm', as: 'item_payoff_confirm'
    post 'orders/:id/ordered', to: 'orders#ordered', as: 'orders_ordered'
    post 'orders/:id/deliveryinfo', to: 'orders#delivery_info', as: 'orders_food_delivery_info'
    get 'users/profile', to: 'profile#edit', as: 'profile_edit'
  end

  if Rails.env.development?
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end

end
