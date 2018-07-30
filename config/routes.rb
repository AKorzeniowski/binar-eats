Rails.application.routes.draw do
  root 'home#welcome'
  devise_for :users, controllers: { registrations: 'users/registrations'  }

  authenticate :user do

    get 'places/index'
    resources :places
    resources :items, only:[:new, :create, :show, :update, :destroy]
    resources :orders, only:[:new, :create, :index, :edit, :update]
    get 'orders/:id/payment/' => 'orders#payment', as: 'orders_payment'
    get 'orders/:id', to: 'items#new'
    get 'order/:id/items', to: 'orders#items', as: 'order_items'
    get 'order/done', to: 'orders#done'
    post 'order/:id/send_payoff', to: 'orders#send_payoff', as: 'orders_payoff'
    get 'item/:id/payoff', to: 'item#payoff', as: 'item_payoff'
  end

end
