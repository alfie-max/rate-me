Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: "omniauth"}
  root "users#index"

  resource :users do
    member do
      get :sync_github
    end
  end
end
