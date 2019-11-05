require 'rails_helper'

RSpec.describe WaitingRoom do
  it 'should raise if no name is provided' do
    expect { WaitingRoom.new({name: nil, user_ids: nil}) }.to raise_error BusinessError, 'Name required'
  end

  it 'should raise if no user_ids are provided' do
    expect { WaitingRoom.new(name: 'my waiting room', user_ids: []) }.to raise_error BusinessError, 'The creator must join the room'
  end

  it 'should be created with a random uuid id' do
    wr = WaitingRoom.new(name: 'my waiting room', user_ids: ['creator_id'])

    expect(wr.id).to be_a(String)
    expect(wr.id.size).to eq(36)
  end

  it "should allow game to start if players count is equal or above #{Game::MIN_PLAYERS_IN_GAME}" do
    wr_not_startable = WaitingRoom.new(name: 'my waiting room 1', user_ids: %w(creator_id))

    expect(wr_not_startable.can_start_game?).to be false

    wr_startable = WaitingRoom.new(name: 'my waiting room 2', user_ids: %w(creator_id other_id))

    expect(wr_startable.can_start_game?).to be true
  end

  it 'should allow user to join the room' do
    wr = WaitingRoom.new(name: 'my waiting room 2', user_ids: %w(creator_id other_id))

    user = User.new(username: 'jean', email: 'Francis', auth_id: 'an_auth_id')
    wr.join(user)

    expect(wr.user_ids).to include(user.auth_id)
  end

  it "should not allow user to join the room if room if full (players count == #{Game::MAX_PLAYERS_IN_GAME})" do
    wr = WaitingRoom.new(name: 'my waiting room 2', user_ids: %w(creator_id other_id third_id forth fifth))

    user = User.new(username: 'jean', email: 'Francis', auth_id: 'an_auth_id')
    expect { wr.join(user) }.to raise_error BusinessError, "Room #{wr.name} is full"
  end

  it 'should not allow user to join the room if he is already in' do
    wr = WaitingRoom.new(name: 'my waiting room 2', user_ids: %w(creator_id))

    creator = User.new(username: 'jean', email: 'Francis', auth_id: 'creator_id')
    expect { wr.join(creator) }.to raise_error BusinessError, "#{creator.username} already in the waiting room"
  end

  it 'should know whether a user is in or not' do
    wr = WaitingRoom.new(name: 'my waiting room 2', user_ids: %w(creator_id))

    expect(wr.include?('creator_id')).to be true
    expect(wr.include?('jacque')).to be false
  end

  describe 'game start' do

    it 'should raise if user starter is not in the waiting room' do
      user_starter_id = 'foreigner'

      wr = WaitingRoom.new(name: 'my waiting room 2', user_ids: %w(creator_id))

      expect { wr.start_game(user_starter_id) }.to raise_error BusinessError
    end

    it 'should raise if there is not enough players to start' do
      user_starter_id = 'creator_id'
      wr = WaitingRoom.new(name: 'my waiting room 2', user_ids: [user_starter_id])

      expect { wr.start_game(user_starter_id) }.to raise_error BusinessError
    end

    it 'should return an GameStarted event' do
      user_starter_id = 'creator_id'

      wr = WaitingRoom.new(name: 'my waiting room 2', user_ids: [user_starter_id, 'julio_id'])

      event = wr.start_game(user_starter_id)

      expect(event.origin_room_id).to eq(wr.id)
    end
  end
end
