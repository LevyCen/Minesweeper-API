Rails.application.routes.draw do

  #GET POST AND DELETE for users
  resources :users, only: [:index, :show, :create, :destroy]

  get '/myboards/:id', to: 'my_boards#show'
  post '/newgame', to: 'my_boards#create'
  delete '/myboards', to: 'my_boards#destroy'
  
  post 'square/open', to: 'squares#open_square'
  
end
