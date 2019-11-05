class WaitingRoom::JoinCommand
  attr_reader :waiting_room_id, :user

  def initialize(waiting_room_id, user)
    @waiting_room_id = waiting_room_id
    @user = user
  end
end

class WaitingRoom::Join < Command::UseCase

  def initialize(repository)
    @repository = repository
  end

  def call(command)
    waiting_room_id = command.waiting_room_id
    user = command.user

    waiting_room = @repository.load(waiting_room_id)

    event = waiting_room.join(user)

    @repository.add(waiting_room)

    Command::Response.new(nil, [event])
  end

  def listen_to
    WaitingRoom::JoinCommand
  end
end
