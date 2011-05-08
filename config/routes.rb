Abredatos2011::Application.routes.draw do
  

  resources :sources
  resources :screenshots

  resources :categories

  resources :apps do
    resources :comments
  end

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  get "home/index"

  root :to => "home#index"
  
end
