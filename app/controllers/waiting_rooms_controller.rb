# frozen_string_literal: true

class WaitingRoomsController < ActionController::API
  include Secured

  def create
    room_name = params[:name]

    command = WaitingRoom::CreateCommand.new(room_name, current_user)

    response = CommandBus.send(command)

    waiting_room = response.value

    render json: WaitingRoomSerializer.new(waiting_room), status: :created
  end

  def join
    waiting_room_id = params[:id]

    join_room = WaitingRoom::JoinCommand.new(waiting_room_id, current_user)

    CommandBus.send(join_room)

    head :no_content
  end

  def show
    id = params[:id]

    room = repository.load(id)

    render json: WaitingRoomSerializer.new(room), status: :ok
  end

  def start_game
    id = params[:id]

    start_game = WaitingRoom::StartGameCommand.new(id, current_user.auth_id)
    response = CommandBus.send(start_game)

    game_id = response.value
    render status: :created, location: game_url(game_id)
  end

  private

  def repository
    Repositories.get('WaitingRoomRepository')
  end
end
