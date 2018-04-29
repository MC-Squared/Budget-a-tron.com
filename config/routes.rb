Rails.application.routes.draw do
  resources :category_rules, except: [:index]
  resources :categories, except: [:index]
  resources :bank_accounts do
    resources :bank_transactions
    post 'imports/create'
  end

  get 'dashboard(/:timespan(/:page))', to: 'bank_accounts#index', as: 'dashboard'

  root to: 'pages#home'
  get 'about', to: 'pages#about'
  get 'pricing', to: 'pages#pricing'
  get 'features', to: 'pages#features'
  get 'howto', to: 'pages#howto'

  devise_for :users
end
