class Game::Create
  def initialize(repository)
    @repository = repository
  end

  def call(player_names:)
    players = Game.prepare_players(player_names)

    game = Game.new(players)

    @repository.add(game)

    game
  end
end