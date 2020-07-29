# frozen_string_literal: true

Rails.application.routes.draw do
  post 'user_token' => 'user_token#create'

  resources :users, except: %i[new edit] do
    get :me, on: :collection
  end

  resources :campaigns, except: %i[new edit]
  resources :hierarchy_elements, except: %i[show new edit]
end
