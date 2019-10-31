class GameController < ActionController::API

  def create
    player_names = params[:player_names]

    game = Game.new(player_names)
    GamePersistence.add(game)

    render json: GameSerializer.new(game), status: :ok
  end

  def show
    game = GamePersistence.load(params[:id])
    render json: GameSerializer.new(game), status: :ok
  end
end
