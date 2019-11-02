class WaitingRoomsController < ActionController::API
  include Secured

  def create
    room_name = params[:name]

    room = WaitingRoom.new(name: room_name, user_ids: [current_user.auth_id])
    repository.add(room)
    UserWaitingRoom.create!(user: current_user, waiting_room_id: room.id)

    render json: WaitingRoomSerializer.new(room), status: :ok
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
