Rails.application.routes.draw do
  devise_for :users

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resources :projects, only: [:index, :show] do
    resources :vms, only: [:create]
  end
  resources :vms, only: [:index]

  root to: "projects#index"
end
