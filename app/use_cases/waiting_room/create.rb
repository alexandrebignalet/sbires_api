class WaitingRoom::Create
  def initialize(repository)
    @repository = repository
  end

  def call(name:, user_creator:)
    room = WaitingRoom.new(name: name, user_ids: [user_creator.auth_id])

    @repository.add(room)
    UserWaitingRoom.create!(user: user_creator, waiting_room_id: room.id)

    room
  end
end
