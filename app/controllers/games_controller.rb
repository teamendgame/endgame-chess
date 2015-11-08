class GamesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @games = Game.all
  end

  def new
    @game = Game.new
  end

  def create
    Game.create(game_params)
    redirect_to root_path
  end

  def show
    @game = Game.find(params[:id])
  end

  def edit
    @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])
    if @game.update(game_params)
      redirect_to root_path
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
    params.require(:game).permit(:name, :white_player_id, :black_player_id)
  end
end
