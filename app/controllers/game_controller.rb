class GameController < ActionController::API

  before_action :authenticate_user!

  def create
    binding.pry
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
