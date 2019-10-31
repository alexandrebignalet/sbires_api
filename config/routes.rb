Rails.application.routes.draw do
  resources :game, only: [:create, :show]
end
