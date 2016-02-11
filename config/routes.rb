Rails.application.routes.draw do
  devise_for :users

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resources :projects, only: [:index, :show] do
    resources :vms, only: [:create]

    collection do
      get :out_of_funds
    end
  end
  resources :vms, only: [:index]

  resources :reset, only: [:index, :create]
  resources :report, only: [:index]

  root to: "projects#index"
end
