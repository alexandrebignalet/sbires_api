# frozen_string_literal: true

class User::OnGameStarted < Event::Captor
  def call(event)
    origin_room_id = event.origin_room_id

    user_waiting_rooms = UserWaitingRoom.where(waiting_room_id: origin_room_id)
    user_waiting_rooms.each(&:destroy)

    users = User.where(auth_id: event.user_ids)
    users.each do |u|
      UserGame.create(user: u, game_id: event.game_id)
    end
  end

  def event_type
    GameStarted
  end
end
