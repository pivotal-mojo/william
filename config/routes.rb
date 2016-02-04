Rails.application.routes.draw do
  devise_for :users
  resource :dashboard, only: [:show]

  root to: "dashboards#show"
end
