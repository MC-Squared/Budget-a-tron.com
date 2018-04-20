Rails.application.routes.draw do
  resources :category_rules
  resources :categories
  resources :bank_accounts do
    resources :bank_transactions
    post 'imports/create'
  end

  root to: 'pages#home'

  devise_for :users
end
