class PiecesController < ApplicationController
  before_action :check_player_color

  # rubocop:disable Metrics/AbcSize
  def show
    @piece = Piece.find(params[:id])
    @game_pieces = Piece.where(game_id: @piece.game_id)
  end

  def update
    @piece = Piece.find(params[:id])
    @game = Game.find(@piece.game_id)
    @piece.update_attributes(piece_params)
    @game.update_attributes(turn_number: @game.turn_number + 1)
    render text: 'updated!'
  end

  def castle_kingside
    @game = Game.find(params[:game_id])
    if @game.black_player_id == current_user.id
      king = King.find_by(user_id: current_user.id)
      flash[:alert] = "You cannot castle" unless king.can_castle?(7, 7)
    elsif @game.white_player_id == current_user.id
      king = King.find_by(user_id: current_user.id)
      flash[:alert] = "You cannot castle" unless king.can_castle?(0, 7)
    end
    redirect_to game_path(@game)
  end

  def castle_queenside
    @game = Game.find(params[:game_id])
    if @game.black_player_id == current_user.id
      king = King.find_by(user_id: current_user.id)
      flash[:alert] = "You cannot castle" unless king.can_castle?(7, 0)
    elsif @game.white_player_id == current_user.id
      king = King.find_by(user_id: current_user.id)
      flash[:alert] = "You cannot castle" unless king.can_castle?(0, 0)
    end
    redirect_to game_path(@game)
  end

  private

  def check_player_color
    @game = Game.find(params[:game_id])
    return if @game.whos_turn? == current_user.id
    flash[:alert] = "Not your turn!"
    redirect_to game_path(@game)
  end

  def piece_params
    params.require(:piece).permit(:type, :row_position, :col_position)
  end
end
