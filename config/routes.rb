Rails.application.routes.draw do
  root to: 'application#index'

  resources :game, only: [:show] do
    member do
      post :place_pawn
    end

    collection do
      post :start
      get :joinable
    end
  end

  resources :waiting_rooms, only: [:create, :show] do
    member do
      post :join
    end
  end
end
