Myflix::Application.routes.draw do
  get 'home', to: "videos#index"
  root 'pages#front'

  resources :videos, only: [:show] do
    collection do
      post :search, to: "videos#search"
    end
    resources :reviews, only: [:create]
  end

  resources :categories
  resources :queue_items, only: [:create, :destroy]
  post 'update_queue', to: 'queue_items#update_queue'

  get 'my_queue', to: 'queue_items#index'
  get 'register', to: "users#new"
  resources :users, only: [:create]
  get 'sign_in', to: 'sessions#new'
  resources :sessions, only: [:create]
  get 'sign_out', to: 'sessions#destroy'
end
