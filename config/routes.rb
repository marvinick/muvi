Myflix::Application.routes.draw do
  get 'home', to: "videos#index"
  root 'videos#index'

  resources :videos
  resources :categories
end
