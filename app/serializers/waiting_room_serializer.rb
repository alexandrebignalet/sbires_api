class WaitingRoomSerializer

  def initialize(room)
    @id = room.id
    @users = User.where(auth_id: room.user_ids)
    @name = room.name
    @is_full = room.full?
    @can_start_game = room.can_start_game?
  end

end