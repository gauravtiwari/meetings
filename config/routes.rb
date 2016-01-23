Rails.application.routes.draw do
  # Root route
  root to: 'meetings#index'

  # Authentication
  devise_for :users, skip: [:sessions, :passwords, :confirmations, :registrations],  controllers: {omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations'}
  as :user do
    # User settings
    get '/:id/settings' => 'users/registrations#edit',   as: 'edit_user_registration'
    patch '/:id/settings' => 'users/registrations#update', as: 'update_user_registeration'

    # Omniauth
    match 'auth/:provider/callback', to: 'users/sessions#create', via: [:get, :post]
    match 'auth/failure', to: redirect('/'), via: [:get, :post]
  end

  # Meetings resource
  resources :meetings, only: [:index, :show]

  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'
end
