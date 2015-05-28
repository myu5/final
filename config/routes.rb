Rails.application.routes.draw do
  root 'recipes#index'

  # User Sign Up#
  patch "/users/:id" => 'users#update'
  get "/signup" => 'users#new'
  get "/users/:id" => 'users#show'
  post "/users" => 'users#create'
  

  # User Update Profile
  get "/users/:id/edit" => 'users#edit'
  patch "/change_password/:id" => 'users#update_password'
  get "/change_password/:id/edit_password" => 'users#edit_password'
  
  #Forget Password Route
  get "/forget_password"=> 'users#forget_password'
  post "/forget_password" => 'users#send_password'

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
