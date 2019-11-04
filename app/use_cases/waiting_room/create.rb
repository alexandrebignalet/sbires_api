class WaitingRoom::Create
  def initialize(repository)
    @repository = repository
  end

  def call(name:, current_user:)
    room = WaitingRoom.new(name: name, user_ids: [current_user.auth_id])

    @repository.add(room)
    UserWaitingRoom.create!(user: current_user, waiting_room_id: room.id)

    room
  end
end
