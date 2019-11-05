# frozen_string_literal: true

RSpec.describe Game::Create do
  it 'should save the created game' do
    repository = InMemoryRepository.new

    player_names = %w[Jean Francois]
    create_game = Game::CreateCommand.new(player_names)

    response = Game::Create.new(repository).call(create_game)
    game = response.value

    expect(game).to_not be nil
    created_game = repository.load(game.id)
    expect(created_game).to_not be nil
    expect(created_game.id).to eq game.id
  end
end
