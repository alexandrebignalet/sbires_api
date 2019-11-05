class WaitingRoomCreated
  attr_reader :waiting_room_id, :creator_id

  def initialize(waiting_room_id, creator_id)
    @waiting_room_id = waiting_room_id
    @creator_id = creator_id
  end
end