Rails.application.routes.draw do
  root "staticpages#index"
  devise_for :users

  resources :suggestions, except: [:update, :show, :edit]
  resources :shops

  namespace :admin do
    get "/" => "staticpages#index"
    resources :requests
    resources :shop_types
    resources :categories
  end

  namespace :shop_owner do
    resources :shops do
      resources :albums do
        resources :images
      end
    end
  	resources :suggestions, only: [:index, :update, :destroy]
    resources :tables
  end
end
