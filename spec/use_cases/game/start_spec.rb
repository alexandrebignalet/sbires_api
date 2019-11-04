require 'rails_helper'

RSpec.describe Game::Start do
  let(:waiting_room_repository) { InMemoryRepository.new }
  let(:game_repository) { InMemoryRepository.new }
  let(:user_room_creator) { User.create!(username: 'john', email: 'john@example.org', auth_id: 'john_auth_id') }
  let(:room) { WaitingRoom::Create.new(waiting_room_repository).call(name: 'room', user_creator: user_room_creator) }
  let(:second_user_room) { User.create!(username: 'jack', email: 'jack@example.org', auth_id: 'jack_auth_id') }


  it 'should raise if current user not in the waiting room' do
    not_in_room_user = User.create!(username: 'user', email: 'user@example.org', auth_id: 'user_auth_id')

    expect { start_game.call(waiting_room_id: room.id, current_user: not_in_room_user) }.to raise_error ActiveRecord::RecordNotFound
  end

  it 'should raise if game cannot be started due to lack of players in waiting room' do
    expect { start_game.call(waiting_room_id: room.id, current_user: user_room_creator) }.to raise_error BusinessError
  end

  describe 'saved a new game' do
    let(:game_repository) { double(add: nil) }

    before do
      WaitingRoom::Join.new(waiting_room_repository).call(waiting_room_id: room.id, user: second_user_room)
      start_game.call(waiting_room_id: room.id, current_user: user_room_creator)
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

  def start_game
    Game::Start.new(waiting_room_repository, game_repository)
  end
end