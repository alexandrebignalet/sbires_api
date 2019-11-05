class UserJoinedWaitingRoom
  attr_reader :waiting_room_id, :user_auth_id

  def initialize(waiting_room_id, user_auth_id)
    @waiting_room_id = waiting_room_id
    @user_auth_id = user_auth_id
  end
end