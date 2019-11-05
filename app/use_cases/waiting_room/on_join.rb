# frozen_string_literal: true

class WaitingRoom::OnJoin
  EVENT_TYPE = 'on_waiting_room_joined'

  def call(event)
    UserWaitingRoom.create!(user: event[:user], waiting_room_id: event[:waiting_room_id])
  end

  def event_type
    EVENT_TYPE
  end
end
