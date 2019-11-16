Rails.application.routes.draw do
  resources :trades
  resources :orders
  resources :companies
  resources :users do
    resources :deposits
    resources :holdings
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'orders#index'
end
