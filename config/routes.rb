Rails.application.routes.draw do
  resources :holdings
  resources :trades
  resources :orders
  resources :companies
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'companies#index'
end
