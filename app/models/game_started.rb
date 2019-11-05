class GameStarted
  attr_reader :origin_room_id, :game_id, :user_ids

  def initialize(origin_room_id, game_id, user_ids)
    @origin_room_id = origin_room_id
    @game_id = game_id
    @user_ids = user_ids
  end
end