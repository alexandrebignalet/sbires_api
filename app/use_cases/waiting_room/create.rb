class WaitingRoom::CreateCommand
  attr_reader :name, :user_creator

  def initialize(name, user_creator)
    @name = name
    @user_creator = user_creator
  end
end

class WaitingRoom::Create < Command::UseCase

  def initialize(repository)
    @repository = repository
  end

  def call(command)
    room = WaitingRoom.new(name: command.name, user_ids: [command.user_creator.auth_id])

    @repository.add(room)
    UserWaitingRoom.create!(user: command.user_creator, waiting_room_id: room.id)

    Command::Response.new(room)
  end

  def listen_to
    WaitingRoom::CreateCommand
  end
end
