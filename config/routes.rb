Rails.application.routes.draw do
  resources :bank_accounts
  root to: 'pages#home'

  devise_for :users
end
