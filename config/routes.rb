# frozen_string_literal: true

Rails.application.routes.draw do
  post 'user_token' => 'user_token#create'

  resources :users, except: %i[new edit] do
    get :me, on: :collection
  end

  resources :campaigns, except: %i[new edit]
  resources :hierarchy_elements, except: %i[show new edit] do
    resources :content_texts, except: %i[show new edit], shallow: true do
      patch :reorder, on: :collection
    end
  end
end
