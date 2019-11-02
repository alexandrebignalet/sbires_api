class GameController < ActionController::API
  include Secured

  def create
    player_names = params[:player_names]

    command = CreateGame.new(player_names)
    game = CreateGameHandler.new.call command

    render json: GameSerializer.new(game), status: :ok
  end

  def show
    game = GamePersistence.load(params[:id])
    render json: GameSerializer.new(game), status: :ok
  end
end
