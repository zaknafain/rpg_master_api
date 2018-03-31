Rails.application.routes.draw do

  post 'user_token' => 'user_token#create'

  resources :users, only: [:index, :show, :destroy]
end
