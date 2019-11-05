# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WaitingRoom::Create do
  let(:repository) { Repositories.get('WaitingRoomRepository') }
  let(:user) { User.create!(username: 'jean', email: 'jean@exmaple.org', auth_id: 'auth_id') }
  let(:room_name) { 'room_name' }

  before do
    create_room = WaitingRoom::CreateCommand.new(room_name, user)
    response = CommandBus.send(create_room)
    @created_room = response.value
  end

  it 'should persist a room containing the name and user passed in' do

    expect(repository.load(@created_room.id)).to eq(@created_room)
    expect(@created_room.name).to eq(room_name)
    expect(@created_room.user_ids).to include(user.auth_id)
  end

  it 'should have attached creator the waiting room id' do
    expect(user.waiting_rooms.first.waiting_room_id).to eq @created_room.id
  end
end
