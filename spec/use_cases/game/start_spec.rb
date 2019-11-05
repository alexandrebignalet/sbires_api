require 'rails_helper'

RSpec.describe Game::Start do
  let(:waiting_room_repository) { InMemoryRepository.new }
  let(:game_repository) { InMemoryRepository.new }
  let(:user_room_creator) { User.create!(username: 'john', email: 'john@example.org', auth_id: 'john_auth_id') }

  let(:room) do
    create_room = WaitingRoom::CreateCommand.new('room', user_room_creator)
    response = WaitingRoom::Create.new(waiting_room_repository).call(create_room)
    response.value
  end

  let(:second_user_room) { User.create!(username: 'jack', email: 'jack@example.org', auth_id: 'jack_auth_id') }


  it 'should raise if current user not in the waiting room' do
    not_in_room_user = User.create!(username: 'user', email: 'user@example.org', auth_id: 'user_auth_id')
    start_game = Game::StartCommand.new(room.id, not_in_room_user)
    expect { do_start_game.call(start_game) }.to raise_error ActiveRecord::RecordNotFound
  end

  it 'should raise if game cannot be started due to lack of players in waiting room' do
    start_game = Game::StartCommand.new(room.id, user_room_creator)
    expect { do_start_game.call(start_game) }.to raise_error BusinessError
  end

  describe 'saved a new game' do
    let(:game_repository) { double(add: nil) }

    before do
      join_room = WaitingRoom::JoinCommand.new(room.id, second_user_room)
      WaitingRoom::Join.new(waiting_room_repository).call(join_room)

      start_game = Game::StartCommand.new(room.id, user_room_creator)
      do_start_game.call(start_game)

      @saved_game = nil
      expect(game_repository).to have_received(:add) { |arg| @saved_game = arg }
    end

    it 'should have persisted an initialized game' do
      players_names = @saved_game.players.map(&:name)

      expect(players_names).to include(user_room_creator.username)
      expect(players_names).to include(second_user_room.username)
    end

    it 'should have attached users the created game' do
      expect(second_user_room.games.map(&:game_id)).to include(@saved_game.id)
      expect(user_room_creator.games.map(&:game_id)).to include(@saved_game.id)
    end

    it 'should have destroyed the waiting room' do
      expect { waiting_room_repository.load(room.id) }.to raise_error EntityNotFound
    end
  end

  def do_start_game
    Game::Start.new(waiting_room_repository, game_repository)
  end
end