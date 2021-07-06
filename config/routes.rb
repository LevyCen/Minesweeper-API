Rails.application.routes.draw do

  #GET POST AND DELETE for users
  resources :users, only: [:index, :show, :create, :destroy]
end
