# frozen_string_literal: true

class WaitingRoomsController < ActionController::API
  include Secured

  def create
    room_name = params[:name]

    repository = Repositories.get('WaitingRoomRepository')
    waiting_room = WaitingRoom::Create
                   .new(repository)
                   .call(name: room_name, current_user: current_user)

    render json: WaitingRoomSerializer.new(waiting_room), status: :created
  end

  def show
    id = params[:id]

    room = repository.load(id)

    render json: WaitingRoomSerializer.new(room), status: :ok
  end

  def join
    id = params[:id]

    room = repository.load(id)

    room.join(current_user)

    repository.add(room)
    UserWaitingRoom.create!(user: current_user, waiting_room_id: room.id)

    head :no_content
  end

  private

  def repository
    Repositories.get('WaitingRoomRepository')
  end
end
