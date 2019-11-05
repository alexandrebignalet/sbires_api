# frozen_string_literal: true
class Game::CreateCommand
  attr_reader :player_names

  def initialize(players_names)
    @player_names = players_names
  end
end

class Game::Create < Command::UseCase

  def initialize(repository)
    @repository = repository
  end

  def call(command)
    players = Game.prepare_players(command.player_names)

    game = Game.new(players)

    @repository.add(game)

    Command::Response.new(game)
  end

  def listen_to
    Game::CreateCommand
  end
end
