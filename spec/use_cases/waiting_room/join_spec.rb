# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WaitingRoom::Create do

  # TODO DECOUPLE AR FROM WAITING ROOM

  let(:repository) { InMemoryRepository.new }
  let(:room_name) { 'room_name' }
  let(:user) { User.create!(username: 'jean', email: 'jean@exmaple.org', auth_id: 'auth_id') }
  let(:join_user) { User.create!(username: 'john', email: 'john@exmaple.org', auth_id: 'john_auth_id') }

  before do
    create_room = WaitingRoom::CreateCommand.new(room_name, user)
    res = WaitingRoom::Create.new(repository).call(create_room)
    @room = res.value

    join_room = WaitingRoom::JoinCommand.new(@room.id, join_user)
    @res = WaitingRoom::Join.new(repository).call(join_room)
  end

  it 'should add a user in the waiting room' do
    expect(@room.user_ids).to include(user.auth_id, join_user.auth_id)
  end

  it 'should return on waiting room joined event' do
    events = @res.events

    expect(events.first.user_auth_id).to eq(join_user.auth_id)
    expect(events.first.waiting_room_id).to eq(@room.id)
  end
end
