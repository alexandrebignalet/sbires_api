Rails.application.routes.draw do
  root to: 'application#index'

  resources :games, only: [:show] do
    member do
      post :place_pawn
      post :draw_card
    end

    collection do
      post :start
    end
  end

  resources :waiting_rooms, only: [:create, :show] do
    member do
      post :join
    end
  end
end
