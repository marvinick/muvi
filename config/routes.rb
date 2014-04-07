Myflix::Application.routes.draw do
  get 'home', to: "videos#index"
  root 'pages#front'

  resources :videos, only: [:show] do
    collection do
      post :search, to: "videos#search"
    end
    resources :reviews, only: [:create]
  end

  namespace :admin do
    resources :videos, only: [:new, :create]
  end

  resources :users, only: [:show, :create]
  resources :relationships, only: [:destroy, :create]
  resources :sessions, only: [:create]
  get 'people', to: 'relationships#index'

  get 'forgot_password', to: 'forgot_passwords#new'
  resources :forgot_passwords, only: [:create]
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'

  resources :categories
  resources :queue_items, only: [:create, :destroy]
  post 'update_queue', to: 'queue_items#update_queue'

  get 'sign_in', to: 'sessions#new'
  get 'my_queue', to: 'queue_items#index'
  get 'register', to: "users#new"
  get 'register/:token', to: "users#new_with_invitation_token", as: 'register_with_token'
  get 'sign_out', to: 'sessions#destroy'

  resources :password_resets, only: [:show, :create]
  get 'expired_token', to: 'password_resets#expired_token'

  resources :invitations, only: [:new, :create]
end
