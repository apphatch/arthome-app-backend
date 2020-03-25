Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post 'login', to: 'sessions#create', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout

  resources :users
  resources :sessions, only: [:new, :create, :destroy]

  resources :checklists do
    collection do
      get :index_by_user
      get :index_by_shop
    end
  end

  resources :checklist_items do
  end

  resources :checkin_checkouts do
    collection do
      get :report
    end
  end

  resources :shops do
    collection do
      get :index_by_user
    end

    member do
      post :checkin
      post :checkout
    end
  end

  resources :stocks do
    collection do
      get :index_by_shop
    end
  end
end
