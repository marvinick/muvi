Myflix::Application.routes.draw do
  get 'home', to: "videos#index"
  root 'pages#front'

  resources :videos, only: [:show] do
    collection do
      post :search, to: "videos#search"
    end
  end
  resources :categories
  get 'register', to: "users#new"
  resources :users, only: [:create]
  get 'sign_in', to: 'sessions#new'

end
