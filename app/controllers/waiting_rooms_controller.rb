# frozen_string_literal: true

class WaitingRoomsController < ActionController::API
  include Secured

  def create
    room_name = params[:name]

    waiting_room = WaitingRoom::Create
                   .new(repository)
                   .call(name: room_name, user_creator: current_user)

    render json: WaitingRoomSerializer.new(waiting_room), status: :created
  end

  def join
    waiting_room_id = params[:id]

    WaitingRoom::Join.new(repository).call(waiting_room_id: waiting_room_id,
                                           user: current_user)

    head :no_content
  end

  def show
    id = params[:id]

    room = repository.load(id)

    render json: WaitingRoomSerializer.new(room), status: :ok
  end

  private

  def repository
    Repositories.get('WaitingRoomRepository')
  end
end
