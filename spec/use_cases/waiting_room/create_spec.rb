# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WaitingRoom::Create do

  # TODO DECOUPLE AR FROM WAITING ROOM

  it 'should persist a room containing the name and user passed in' do
    repository = InMemoryRepository.new

    room_name = 'room_name'
    user = User.create!(username: 'jean', email: 'jean@exmaple.org', auth_id: 'auth_id')

    created_room = WaitingRoom::Create.new(repository).call(name: room_name, user_creator: user)

    expect(repository.load(created_room.id)).to eq(created_room)
    expect(created_room.name).to eq(room_name)
    expect(created_room.user_ids).to include(user.auth_id)

    expect(user.waiting_rooms.first.waiting_room_id).to eq created_room.id
  end
end
