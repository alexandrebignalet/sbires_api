# frozen_string_literal: true

require 'rails_helper'
require_relative './sbires_api_helper'

RSpec.describe WaitingRoomsController, type: :request do
  it 'should create a waiting room' do
    waiting_room_resource_path = '/waiting_rooms'
    user = create_authenticated_user(username: 'jean', email: 'jean@example.org', auth_id: 'user_auth_id')
    waiting_room_name = 'waiting_room'

    post waiting_room_resource_path, params: { name: waiting_room_name }

    expect(response).to be_successful
    expect(response.status).to be(201)
    expect(response.parsed_body['name']).to eq(waiting_room_name)
    expect(response.parsed_body['is_full']).to eq(false)
    expect(response.parsed_body['can_start_game']).to eq(false)
    expect(response.parsed_body['name']).to eq(waiting_room_name)
    expect(response.parsed_body['users']).to include(hash_including('id' => user.id, 'auth_id' => user.auth_id))
  end

  it 'should allow user to join a waiting room' do
    user = create_authenticated_user(username: 'jean', email: 'jean@example.org', auth_id: 'user_auth_id')
    waiting_room_name = 'waiting_room'
    repository = Repositories.get('WaitingRoomRepository')
    a_room = WaitingRoom::Create.new(repository).call(name: waiting_room_name, user_creator: user)

    john_user = create_authenticated_user(username: 'john', email: 'john@example.org', auth_id: 'john_auth_id')

    waiting_room_resource_path = "/waiting_rooms/#{a_room.id}/join"
    post waiting_room_resource_path

    expect(response).to be_successful
    expect(response.status).to be(204)
  end

end
