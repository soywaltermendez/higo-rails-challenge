Rails.application.routes.draw do
  devise_for :users

  # Comment out to use React
  root to: 'invoices#index'

  resources :invoices
  resources :people, only: :show

  # Uncomment to use React
  # root to: 'react_app#index'
  # get '*path', to: 'react_app#index'
end
