Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post 'login', to: 'sessions#create', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout

  resources :sessions, only: [:new, :create, :destroy] do
    collection do
      get :keep_alive
    end
  end

  resources :users do
    collection do
      get  :import_template
      get  :export_oos
    end

    member do
      post :lock
      post :unlock
    end
  end

  resources :checklists do
    collection do
      get  :index_by_user
      get  :index_by_shop
      get  :index_by_user_shop
      post :import
      get  :import_template
    end

    member do
      post :update_checklist_items
      get  :show_incomplete_items
      get :search_checklist_items
    end
  end

  resources :checklist_items do
    collection do
      get  :index_by_checklist
      post :import
      get  :import_template
    end

    member do
      post :update
    end
  end

  resources :checkin_checkouts do
    collection do
      get :report
      get :index_shop
    end
  end

  resources :shops do
    collection do
      get :index_by_user
      get :search
      get :import_template
      get :import_osa
    end

    member do
      post :checkin
      post :checkout
      post :shop_checkout
    end
  end

  resources :stocks do
    collection do
      get  :index_by_shop
      get  :search
      post :import
      get  :import_template
    end
  end
end
