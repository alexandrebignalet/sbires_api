# frozen_string_literal: true

event_captors = [
    WaitingRoom::OnJoin.new
]

event_bus = Event::Bus.new(event_captors)

waiting_room_repository = Repositories.get('WaitingRoomRepository')
game_repository = Repositories.get('GameRepository')

use_cases = [
  Game::Create.new(game_repository),
  Game::Start.new(waiting_room_repository, game_repository),

  WaitingRoom::Create.new(waiting_room_repository),
  WaitingRoom::Join.new(waiting_room_repository)
]

middlewares = [
  Event::DispatcherMiddleware.new(event_bus)
]

CommandBus = Command::Bus.new(use_cases, middlewares)
