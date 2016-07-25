class GamesController < ApplicationController
  before_action :authenticate_user!
  before_action :current_game, only: [:show, :update]
  before_action :own_game?, only: [:show]
  before_action :new_game?, only: [:show]
  before_action :check_status, only: [:show]

  # rubocop:disable Metrics/LineLength

  def index
    return unless user_signed_in?
    @games = Game.where(black_player_id: nil).where.not(white_player_id: current_user.id).page(params[:page])
    @my_games = my_games
    flash.keep(:game_status)
  end

  def search
    @results = search_query(params[:email]).page(params[:page])
  end

  def new
    @game = Game.new
  end

  def create
    Game.create(game_params)
    redirect_to games_path
  end

  def show
    @pieces = @game.pieces
  end

  def update
    return unless @game.update(game_params)

    @game.populate_board!
    redirect_to games_path
  end

  private

  def game_params
    params.require(:game).permit(:name, :white_player_id, :black_player_id, :turn_number)
  end

  # List of games where current_user is either
  # black or white player
  def my_games
    return unless user_signed_in?
    @my_games = Game.where('white_player_id = ? or black_player_id = ?', current_user.id, current_user.id).where(winning_player_id: nil).order(:created_at)
  end

  # Find unstarted games where the white_player_id
  # matches the searched e-mail address
  def search_query(params)
    user = User.find_by(email: params)
    Game.where(white_player_id: user.id, black_player_id: nil).order(:created_at)
  end

  # rubocop:disable Metrics/AbcSize
  # Prevent access to games_controller#show if player
  # is not a part of that game
  def own_game?
    return unless @game.black_player_id
    return if @game.white_player_id == current_user.id || @game.black_player_id == current_user.id

    flash[:alert] = "Sorry, you're not a player in that game"
    redirect_to games_path
  end

  # Prevent access to games_controller#show if game
  # only has 1 player
  def new_game?
    return if @game.black_player_id

    flash[:alert] = "Sorry, you have to join the game first"
    redirect_to games_path
  end

  def check_status
    stalemate?
    checkmate?
  end

  # Check if game is in checkmate
  # If so, present message indicating winner
  def checkmate?
    return unless @game.determine_checkmate

    if @game.turn_number.even?
      @game.update(winning_player_id: @game.black_player_id)
    elsif game.turn_number.odd?
      @game.update(winning_player_id: @game.white_player_id)
    end
  end

  def stalemate?
    return unless @game.determine_stalemate

    @game.update(winning_player_id: (-1))
  end
  
  def current_game 
    @game = Game.find(params[:id])
  end 
end
