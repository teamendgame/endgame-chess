class GamesController < ApplicationController
  before_action :authenticate_user!

  # rubocop:disable Metrics/LineLength

  def index
    return unless user_signed_in?
    @games = Game.where(black_player_id: nil).where.not(white_player_id: current_user.id).page(params[:page])
    @my_games = my_games
  end

  def my_games
    return unless user_signed_in?
    @my_games = Game.where('white_player_id = ? or black_player_id = ?', current_user.id, current_user.id).where(winning_player_id: nil).order(:created_at)
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
    @game = Game.find(params[:id])
    @pieces = @game.pieces.all
  end

  def edit
    @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])
    if @game.update(game_params)
      @game.populate_board!
      redirect_to games_path
    else
      render 'edit'
    end
  end

  def destroy
    @game = Game.find(params[:id])
    @game.destroy
    flash[:notice] = "Game Deleted"
    redirect_to root_path
  end

  private

  def game_params
    params.require(:game).permit(:name, :white_player_id, :black_player_id, :turn_number)
  end

  def search_query(params)
    user = User.find_by(email: params)
    Game.where(white_player_id: user.id, black_player_id: nil).order(:created_at)
  end
end
