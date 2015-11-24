class PiecesController < ApplicationController
  # rubocop:disable Metrics/AbcSize
  def show
    @piece = Piece.find(params[:id])
    @game_pieces = Piece.where(game_id: @piece.game_id)
  end

  def update
    @piece = Piece.find(params[:id])
    @game = Game.find(@piece.game_id)
    # rubocop:disable Metrics/LineLength
    redirect_to game_path(@piece.game_id) if @piece.update_attributes(row_position: params[:row_position], col_position: params[:col_position]) && @game.update_attributes(turn_number: @game.turn_number + 1)
  end
end
