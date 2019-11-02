class ApplicationController < ActionController::API

  def index
    render json: { sbires: 'game' }, status: :ok
  end
end
