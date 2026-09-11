Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  mount ActionCable.server => "/cable"
  
  resource :profile, only: [:show, :edit, :update]

  resources :posts

  namespace :admin do
    resources :categories
  end

  get "up" => "rails/health#show", as: :rails_health_check

  resources :contacts, only: [:index, :create, :destroy] do
    member do
      patch :accept
      patch :reject
    end
  end

  resources :groups, only: [:index, :show, :new, :create] do
    member do
      post :join
      delete :leave
    end
  end

  resources :matches, only: [:index]
end
