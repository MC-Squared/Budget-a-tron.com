Rails.application.routes.draw do
  resources :category_rules, except: [:index]
  resources :categories, except: [:index]
  resources :bank_accounts do
    resources :bank_transactions
    post 'imports/create'
  end

  root to: 'pages#home'
  get 'about', to: 'pages#about'

  devise_for :users
end
