# frozen_string_literal: true

RSpec.describe Game::Create do
  it 'should save the created game' do
    repository = InMemoryRepository.new

    player_names = %w[Jean Francois]
    create_game = Game::Create.new(repository)

    game = create_game.call(player_names: player_names)

    expect(game).to_not be nil
    created_game = repository.load(game.id)
    expect(created_game).to_not be nil
    expect(created_game.id).to eq game.id
  end
end
