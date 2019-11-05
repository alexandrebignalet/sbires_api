# frozen_string_literal: true

waiting_room_repository = Repositories.get('WaitingRoomRepository')
game_repository = Repositories.get('GameRepository')

user_service = User

event_captors = [
    WaitingRoom::OnJoin.new,

    User::OnGameStarted.new,
    Game::OnGameStarted.new(game_repository, user_service)
]

event_bus = Event::Bus.new(event_captors)



use_cases = [
  WaitingRoom::Create.new(waiting_room_repository),
  WaitingRoom::Join.new(waiting_room_repository),
  WaitingRoom::StartGame.new(waiting_room_repository)
]

middlewares = [
  Event::DispatcherMiddleware.new(event_bus)
]

CommandBus = Command::Bus.new(use_cases, middlewares)
