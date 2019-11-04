class WaitingRoom::Join
  def initialize(repository)
    @repository = repository
  end

  def call(waiting_room_id:, user:)
    waiting_room = @repository.load(waiting_room_id)

    waiting_room.join(user)

    @repository.add(waiting_room)

    UserWaitingRoom.create!(user: user, waiting_room_id: waiting_room_id)
  end
end
