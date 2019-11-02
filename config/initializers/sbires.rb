# frozen_string_literal: true

require 'sbires'

Sbires.configure do |config|
  config.game_repository = Repositories.get('GameRepository')
end
