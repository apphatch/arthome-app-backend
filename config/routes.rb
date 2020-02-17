Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post 'login', to: 'sessions#create', as: :login
  post 'logout', to: 'sessions#destroy', as: :logout

  resource :login do
  end

  resources :users
  resources :sessions, only: [:new, :create, :destroy]

  resources :checklists do
  end

  resources :shops do
  end
end
