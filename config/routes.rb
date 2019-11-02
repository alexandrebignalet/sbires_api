Rails.application.routes.draw do
  root to: 'application#index'

  resources :game, only: [:create, :show]
end
