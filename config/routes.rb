Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: "omniauth"}
  root "users#index"

  resources :users do
    member do
      get :sync_github
      get :sync_stackoverflow
    end
  end
end
