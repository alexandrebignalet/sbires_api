class WaitingRoom::StartGameCommand
  attr_reader :waiting_room_id, :user_starter_id

  def initialize(waiting_room_id, user_starter_id)
    @waiting_room_id = waiting_room_id
    @user_starter_id = user_starter_id
  end
end

class WaitingRoom::StartGame
  def initialize(room_repository)
    @repository = room_repository
  end

  def call(command)
    room = @repository.load(command.waiting_room_id)

    game_started = room.start_game(command.user_starter_id)

    @repository.delete(command.waiting_room_id)

    Command::Response.new(game_started.game_id, [game_started])
  end

  def listen_to
    WaitingRoom::StartGameCommand
  end
end