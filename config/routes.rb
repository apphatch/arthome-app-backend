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

  resources :io do
    collection do
      exporters = {
        oos: :oos_exporter,
        sos: :sos_exporter,
        npd: :npd_exporter,
        promotions: :promotions_exporter,
        osaweekend: :osaweekend_exporter,
        rental: :rental_exporter,
      }
      exporters.each do |k, v|
        get "export_osa_#{k.to_s}"
      end

      importers = {
        users: :user_importer,
        shops: :shop_importer,
        stocks: :stock_importer,
        checklists: :checklist_importer,
        checklist_items: :checklist_item_importer,
        full: :master_importer,
        photos: :photo_importer
      }
      importers.each do |k, v|
        post "import_osa_#{k.to_s}"
      end
    end
  end
end
