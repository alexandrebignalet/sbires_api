require 'rails_helper'

RSpec.describe WaitingRoom::StartGame do

  let(:user) { User.create!(username: 'jean', email: 'jean@exmaple.org', auth_id: 'auth_id') }
  let(:user_jano) { User.create!(username: 'jeano', email: 'jeano@exmaple.org', auth_id: 'jno_auth_id') }
  let(:waiting_room_id) do
    create_room = WaitingRoom::CreateCommand.new('room name', user)
    create_response = CommandBus.send(create_room)
    create_response.value.id
  end
  let(:waiting_room_repository) { Repositories.get('WaitingRoomRepository') }
  let(:game_repository) { Repositories.get('GameRepository') }

  before do
    join_room = WaitingRoom::JoinCommand.new(waiting_room_id, user_jano)
    CommandBus.send(join_room)

    start_game = WaitingRoom::StartGameCommand.new(waiting_room_id, user_jano.auth_id)
    start_game_response = CommandBus.send(start_game)
    @game_id = start_game_response.value
  end

  it 'should remove the waiting room from the repo' do
    expect { waiting_room_repository.load(waiting_room_id) }.to raise_error EntityNotFound
  end

  it 'should remove users waiting room references' do
    expect(user.waiting_rooms.map(&:waiting_room_id)).to_not include(waiting_room_id)
    expect(user_jano.waiting_rooms.map(&:waiting_room_id)).to_not include(waiting_room_id)
  end

  it 'should return the created a game id' do
    game = game_repository.load(@game_id)

    expect(game).to_not be nil
  end

  it 'should have affected games to users playing' do
    expect(user.games.map(&:game_id)).to include(@game_id)
    expect(user_jano.games.map(&:game_id)).to include(@game_id)
  end
end