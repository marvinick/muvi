Myflix::Application.routes.draw do
  get 'home', to: "videos#index"
  root 'pages#front'

  resources :videos, only: [:show] do
    collection do
      post :search, to: "videos#search"
    end
    resources :reviews, only: [:create]
  end

  resources :users, only: [:show, :create]
  resources :relationships, only: [:destroy, :create]
  resources :sessions, only: [:create]
  get 'people', to: 'relationships#index'

  resources :categories
  resources :queue_items, only: [:create, :destroy]
  post 'update_queue', to: 'queue_items#update_queue'

  get 'sign_in', to: 'sessions#new'
  get 'my_queue', to: 'queue_items#index'
  get 'register', to: "users#new"

  get 'sign_out', to: 'sessions#destroy'
end
