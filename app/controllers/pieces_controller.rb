class PiecesController < ApplicationController
  def show
    @piece = Piece.find(params[:id])
    @game_pieces = Piece.where(game_id: @piece.game_id)
  end

  def update
    @piece = Piece.find(params[:id])
    # rubocop:disable Metrics/LineLength
    redirect_to game_path(@piece.game_id) if @piece.update_attributes(row_position: params[:row_position], col_position: params[:col_position])
  end
end
