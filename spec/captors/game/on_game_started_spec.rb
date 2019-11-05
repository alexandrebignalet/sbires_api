# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game::OnGameStarted do
  it 'should save the created game' do
    repository = double(add: nil)
    player_names = %w[Jean Francois]
    user_service = double(usernames_of: player_names)
    captor = Game::OnGameStarted.new(repository, user_service)

    game_id = 'game_id'
    user_ids = %w[123 456]
    game_started = GameStarted.new('room_id', game_id, user_ids)

    captor.call(game_started)

    expect(repository).to have_received(:add).with(have_attributes(id: game_id))
  end
end
