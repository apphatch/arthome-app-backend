Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resource :login do
  end

  resource :session do
  end

  resources :users do
  end

  resources :checklists do
  end

  resources :shops do
  end
end
