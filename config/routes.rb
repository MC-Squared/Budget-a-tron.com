Rails.application.routes.draw do
  resources :bank_accounts do
    resources :bank_transactions
  end
  
  root to: 'pages#home'

  devise_for :users
end
