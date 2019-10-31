class GameSerializer
  def initialize(game)
    @id = game.id
    @players = game.players
    @current_player = game.players[game.current_player_index]
    @current_day = game.current_day
    @state = game.state
  end
end