class Game::OnGameStarted
  def initialize(game_repository, user_service)
    @repository = game_repository
    @user_service = user_service
  end

  def call(event)
    game_id = event.game_id

    players_names = @user_service.usernames_of(event.user_ids)
    players = Game.prepare_players(players_names)

    game = Game.new(players, id: game_id)

    @repository.add(game)
  end

  def event_type
    GameStarted
  end
end