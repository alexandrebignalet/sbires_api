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
    room, event = WaitingRoom.of(name: command.name, creator_id: command.user_creator.auth_id)

    @repository.add(room)

    Command::Response.new(room, [event])
  end

  def listen_to
    WaitingRoom::CreateCommand
  end
end
