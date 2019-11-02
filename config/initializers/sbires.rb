# frozen_string_literal: true

require 'sbires'

GamePersistence = GameRepository.new

Sbires.configure do |config|
  config.game_repository = GamePersistence
end
