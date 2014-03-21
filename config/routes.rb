Myflix::Application.routes.draw do
  get 'home', to: "videos#index"
  root 'videos#index'

  resources :videos, only: [:show] do
    collection do
      post :search, to: "videos#search"
    end
  end
  resources :categories
end
