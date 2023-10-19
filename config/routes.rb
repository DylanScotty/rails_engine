Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do
      namespace :merchants do
        resources :find, only: [:index], controller: "search"
        resources :find_all, only: [:index], controller: "search"
      end
      namespace :items do
        resources :find_all, only: [:index], controller: "search"
      end
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: "merchants/items"
      end
      resources :items, only: [:index, :show, :create, :update, :destroy] do
        get "/merchant", to: "items/merchants#index"
      end

    end
  end
end
