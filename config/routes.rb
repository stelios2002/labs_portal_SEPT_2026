Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  
  resource :profile, only: [:show, :edit, :update]

  namespace :admin do
    resources :categories
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
