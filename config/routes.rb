require 'resque/server'
require 'resque/scheduler'
require 'resque/scheduler/server'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post 'login', to: 'sessions#create', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout

  mount Resque::Server.new, at: "/resque"

  resources :sessions, only: [:new, :create, :destroy] do
    collection do
      get :keep_alive
    end
  end

  resources :photos, only: [:create] do
  end

  resources :users do
    collection do
      get  :import_template
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
      get  :import_template
    end

    member do
      get  :show_incomplete_items
      get :search_checklist_items
    end
  end

  resources :checklist_items do
    collection do
      get  :index_by_checklist
      get  :import_template
      post :bulk_update
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
      get  :index_by_user
      get  :search
      get  :import_template
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
      get  :import_template
    end
  end

  resources :reports do
    collection do
      get :qc_summary
      get :qc_detail
    end
  end

  resources :io do
    collection do
      exporters = [
        'oos_export',
        'sos_export',
        'npd_export',
        'promotion_export',
        'osa_weekend_export',
        'rental_export',
        'checkin_checkout_export',
      ]
      exporters.each do |v|
        get v
      end

      importers = [
        'user_import',
        'shop_import',
        'stock_import',
        'checklist_import',
        'checklist_item_import',
        'master_import',
        'photo_import',
      ]
      importers.each do |v|
        post v
      end
    end
  end
end
