Rails.application.routes.draw do
  resources :category_rules, except: [:index]
  resources :categories, except: [:index]
  resources :bank_accounts, except: [:index] do
    resources :bank_transactions
    post 'imports/create'
  end
  resources :uncategorized_bank_transactions, only: [:index]

  get 'dashboard', to: 'dashboard#index'

  root to: 'pages#home'
  get 'about', to: 'pages#about'
  get 'pricing', to: 'pages#pricing'
  get 'features', to: 'pages#features'
  get 'howto', to: 'pages#howto'

  devise_for :users
end
