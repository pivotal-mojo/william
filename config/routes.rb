Rails.application.routes.draw do
  devise_for :users
  resources :projects, only: [:index, :show] do
    resources :vms
  end

  root to: "projects#index"
end
