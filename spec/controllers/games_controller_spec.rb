# frozen_string_literal: true

require 'rails_helper'
require_relative './sbires_api_helper'

RSpec.describe GamesController, type: :request do

  it 'should start a game from a waiting room' do
    user = create_authenticated_user(username: 'john', email: 'john@example.org', auth_id: 'john_auth_id')

    create_room = WaitingRoom::CreateCommand.new('sbires_room', user)
    res = CommandBus.send(create_room)
    room = res.value

    another_user = create_authenticated_user(username: 'jean', email: 'jean@example.org', auth_id: 'jean_auth_id')
    join_room = WaitingRoom::JoinCommand.new(room.id, another_user)
    CommandBus.send(join_room)

    game_resource_path = '/games/start'

    post game_resource_path, params: { waiting_room_id: room.id }

    expect(response).to be_successful
    expect(response.status).to be(200)
  end

  def waiting_room_repository
    Repositories.get('WaitingRoomRepository')
  end
end
