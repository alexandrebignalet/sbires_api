class GameRepository

  def initialize
    @by_id = {}
  end

  def add(game)
    @by_id[game.id] = game
  end

  def load(id)
    @by_id[id]
  end
end