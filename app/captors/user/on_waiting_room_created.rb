# frozen_string_literal: true

class User::OnWaitingRoomCreated < Event::Captor
  def call(event)
    user = User.find_by(auth_id: event.creator_id)
    UserWaitingRoom.create!(user: user, waiting_room_id: event.waiting_room_id)
  end

  def event_type
    WaitingRoomCreated
  end
end
