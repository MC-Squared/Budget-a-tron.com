Rails.application.routes.draw do
  resources :category_rules, except: [:index]
  resources :categories, except: [:index]
  resources :bank_accounts, except: [:index] do
    resources :bank_transactions
    post 'imports/create'
  end

  get 'dashboard(/:timespan(/:page))', to: 'dashboard#index', as: 'dashboard'

  root to: 'pages#home'
  get 'about', to: 'pages#about'
  get 'pricing', to: 'pages#pricing'
  get 'features', to: 'pages#features'
  get 'howto', to: 'pages#howto'

  devise_for :users
end
