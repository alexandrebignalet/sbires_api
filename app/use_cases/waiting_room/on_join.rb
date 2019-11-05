# frozen_string_literal: true

class WaitingRoom::OnJoin < Event::Captor

  def call(event)
    user = User.find_by(auth_id: event.user_auth_id)
    UserWaitingRoom.create!(user: user, waiting_room_id: event.waiting_room_id)
  end

  def event_type
    UserJoinedWaitingRoom
  end
end
