Rails.application.routes.draw do
  root 'recipes#index'

  resources :recipes
# The "Golden 7" for accessing the 'recipes' resource

  # get '/recipes/new' => 'recipes#new', as: 'new_recipe'
  # post '/recipes' => 'recipes#create', as: 'recipes'

  # get '/recipes' => 'recipes#index'
  # get '/recipes/:id' => 'recipes#show', as: 'recipe'

  # get '/recipes/:id/edit' => 'recipes#edit', as: 'edit_recipe'
  # patch '/recipes/:id' => 'recipes#update'

  # delete '/recipes/:id' => 'recipes#destroy'
end
