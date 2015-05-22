Rails.application.routes.draw do
  root 'recipes#index'

  # User Sign Up#
  get "/signup" => 'users#new'
  post "/users" => 'users#create'
  get "/users/:id" => 'users#show'

  # User Login #
  get "/login" => 'sessions#new'
  post "/sessions" => 'sessions#create'
  get "/logout" => 'sessions#destroy'

  # GOLDEN 7 FROM RESOURCES OF RECIPES, REVIEWS AND TAGS #
  resources :recipes
  delete '/reviews/:id' => 'reviews#destroy', as: 'delete_review'
  resources :reviews, only: [:index, :show, :new, :create]
  resources :tags


end
