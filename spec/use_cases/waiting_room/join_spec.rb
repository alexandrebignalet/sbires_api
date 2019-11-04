# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WaitingRoom::Create do

  # TODO DECOUPLE AR FROM WAITING ROOM

  let(:repository) { InMemoryRepository.new }
  let(:room_name) { 'room_name' }
  let(:user) { User.create!(username: 'jean', email: 'jean@exmaple.org', auth_id: 'auth_id') }
  let(:join_user) { User.create!(username: 'john', email: 'john@exmaple.org', auth_id: 'john_auth_id') }

  before do
    @room = WaitingRoom::Create.new(repository).call(name: room_name, user_creator: user)

    WaitingRoom::Join.new(repository).call(waiting_room_id: @room.id, user: join_user)
  end

  it 'should add a user in the waiting room' do
    expect(@room.user_ids).to include(user.auth_id, join_user.auth_id)
  end

  it 'should attach a waiting room id to the user added' do
    expect(join_user.waiting_rooms.first.waiting_room_id).to eq @room.id
  end
end
