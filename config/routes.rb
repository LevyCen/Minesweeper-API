Rails.application.routes.draw do

  #GET POST AND DELETE for users
  resources :users, only: [:index, :show, :create, :destroy]

  get '/boards/all/:id', to: 'boards#show'
  post '/boards', to: 'boards#create'
  delete '/boards/:id', to: 'boards#destroy'
  
  post 'square/open', to: 'squares#open_square'
  
end
