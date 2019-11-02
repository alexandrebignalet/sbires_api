class GameSerializer
  def initialize(game, current_user)
    @id = game.id
    serialize = serialize_player(current_user)
    @players = game.players.map { |p| serialize.call(p) }
    @current_player = CurrentPlayerSerializer.new(game.players[game.current_player_index])
    @current_day = game.current_day
    @state = game.state
  end

  def serialize_player(current_user)
    lambda do |player|
      if current_user.username == player.name
        OwnPlayerSerializer.new(player)
      else
        OpponentPlayerSerializer.new(player)
      end
    end
  end
end


class OpponentCardSerializer
  def initialize(card)
    @neighbour_name = card.neighbour_name
  end
end

class OwnedCardSerializer < OpponentCardSerializer
  def initialize(card)
    super(card)
    @name = card.name
  end
end

class CurrentPlayerSerializer
  def initialize(player)
    @name = player.name
    @lord_name = player.lord_name
  end
end

class OpponentPlayerSerializer < CurrentPlayerSerializer
  def initialize(player)
    super(player)
    @pawns = player.pawns.count
    @points = player.points
    @spare = player.spare
  end
end

class OwnPlayerSerializer < OpponentPlayerSerializer
  def initialize(player)
    super(player)
    @cards = player.cards
  end
end