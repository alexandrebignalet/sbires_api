# frozen_string_literal: true

class Game::StartCommand
  attr_reader :waiting_room_id, :current_user

  def initialize(waiting_room_id, current_user)
    @waiting_room_id = waiting_room_id
    @current_user = current_user
  end
end

class Game::Start < Command::UseCase
  def initialize(room_repository, game_repository)
    @waiting_room_repository = room_repository
    @game_repository = game_repository
  end

  def call(command)
    current_user = command.current_user
    waiting_room_id = command.waiting_room_id

    current_user.waiting_rooms.find_by!(waiting_room_id: waiting_room_id)

    room = @waiting_room_repository.load(waiting_room_id)
    unless room.can_start_game?
      raise BusinessError, "Cannot start a game with only #{room.user_ids.count} players"
    end

    players_users = User.where(auth_id: room.user_ids)
    player_names = players_users.map(&:username)

    create_game = Game::CreateCommand.new(player_names)
    response = Game::Create.new(@game_repository).call(create_game)
    game = response.value

    @waiting_room_repository.delete(waiting_room_id)

    lord_names_by_player_name = game.players.each_with_object({}) do |p, acc|
      acc[p.name] = p.lord_name
    end

    players_users.each do |user|
      UserGame.create!(user: user, game_id: game.id, lord_name: lord_names_by_player_name[user.username])
    end

    current_user.waiting_rooms.find_by(waiting_room_id: waiting_room_id).destroy

    Command::Response.new game
  end

  def listen_to
    Game::StartCommand
  end
end
