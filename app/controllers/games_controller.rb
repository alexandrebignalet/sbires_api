# frozen_string_literal: true

class GamesController < ApplicationController
  include Secured

  def show
    id = params[:id]
    user_game = current_user.games.find_by!(game_id: id)

    game = game_repository.load(user_game.game_id)

    render json: GameSerializer.new(game, current_user), status: :ok
  end

  def place_pawn
    id = params[:id]
    neighbour_name = params[:neighbour_name]
    user_game = current_user.games.find_by!(game_id: id)

    lord_name = user_game.lord_name
    game = game_repository.load(id)
    game.place_pawn(lord_name, neighbour_name)

    game_repository.add(game)

    head :no_content
  end

  def draw_card
    id = params[:id]
    card_name = params[:card_name]
    play = params[:play]
    user_game = current_user.games.find_by!(game_id: id)

    lord_name = user_game.lord_name
    game = game_repository.load(id)
    game.draw_card(lord_name, card_name, play)

    game_repository.add(game)

    head :no_content
  end

  private

  def waiting_room_repository
    Repositories.get('WaitingRoomRepository')
  end

  def game_repository
    Repositories.get('GameRepository')
  end
end
