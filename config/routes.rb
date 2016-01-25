Rails.application.routes.draw do
  # Root route
  authenticated :user do
    root to: 'meetings#index', as: :authenticated_root
  end

  unauthenticated do
    root to: 'pages#index'
  end

  # Authentication
  devise_for :users, skip: [:registrations, :passwords, :confirmations],  controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}
  as :user do
    # Omniauth
    match 'auth/:provider/callback', to: 'users/sessions#create', via: [:get, :post]
    match 'auth/failure', to: redirect('/'), via: [:get, :post]
  end

  get '/connect_slack', to: 'pages#connect_slack'
  
  resources :users, only: [:update, :edit]

  # Meetings resource
  resources :meetings, only: :index
end
