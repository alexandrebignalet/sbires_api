# frozen_string_literal: true

class Game::Start
  def initialize(room_repository, game_repository)
    @waiting_room_repository = room_repository
    @game_repository = game_repository
  end

  def call(waiting_room_id:, current_user:)
    current_user.waiting_rooms.find_by!(waiting_room_id: waiting_room_id)

    room = @waiting_room_repository.load(waiting_room_id)
    unless room.can_start_game?
      raise BusinessError, "Cannot start a game with only #{room.user_ids.count} players"
    end

    players_users = User.where(auth_id: room.user_ids)
    player_names = players_users.map(&:username)

    game = Game::Create.new(@game_repository).call(player_names: player_names)

    @waiting_room_repository.delete(waiting_room_id)

    lord_names_by_player_name = game.players.each_with_object({}) do |p, acc|
      acc[p.name] = p.lord_name;
    end

    players_users.each do |user|
      UserGame.create!(user: user, game_id: game.id, lord_name: lord_names_by_player_name[user.username])
    end

    current_user.waiting_rooms.find_by(waiting_room_id: waiting_room_id).destroy

    game
  end
end
