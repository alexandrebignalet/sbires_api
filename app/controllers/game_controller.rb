class GameController < ApplicationController
  include Secured

  def start
    room_id = params[:waiting_room_id]
    current_user.waiting_rooms.find_by!(waiting_room_id: room_id)

    room = waiting_room_repository.load(room_id)
    raise "Cannot start a game with only #{room.user_ids.count} players" unless room.can_start_game?

    players_users = User.where(auth_id: room.user_ids)
    player_names = players_users.map(&:username)

    command = CreateGame.new(player_names)
    game = CreateGameHandler.new.call command

    lord_names_by_player_name = game.players.reduce({}) { |acc, p| acc[p.name] = p.lord_name; acc }
    players_users.each { |user| UserGame.create!(user: user, game_id: game.id, lord_name: lord_names_by_player_name[user.username]) }
    waiting_room_repository.delete(room_id)
    current_user.waiting_rooms.find_by(waiting_room_id: room_id).destroy

    render json: GameSerializer.new(game, current_user), status: :ok
  end

  def show
    id = params[:id]
    user_game = current_user.games.find_by!(game_id: id)

    game = game_repository.load(user_game.game_id)

    render json: GameSerializer.new(game, current_user), status: :ok
  end

  def place_pawn
    id = params[:id]
    neighbour_name = params[:neighbour_name]
    user_game = current_user.games.find_by!(game_id: id)

    lord_name = user_game.lord_name
    game = game_repository.load(id)
    game.place_pawn(lord_name, neighbour_name)

    game_repository.add(game)

    head :no_content
  end

  def draw_card
    id = params[:id]
    card_name = params[:card_name]
    play = params[:play]
    user_game = current_user.games.find_by!(game_id: id)

    lord_name = user_game.lord_name
    game = game_repository.load(id)
    game.draw_card(lord_name, card_name, play)

    game_repository.add(game)

    head :no_content
  end

  private

  def waiting_room_repository
    Repositories.get('WaitingRoomRepository')
  end

  def game_repository
    Repositories.get('GameRepository')
  end
end
