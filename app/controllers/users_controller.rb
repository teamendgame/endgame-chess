class UsersController < ApplicationController
  before_action :authenticate_user!
  helper_method :games_won?, :games_lost?, :games_draw?, :games_unfinished?
  
  def show
    @user = User.find(params[:id])
    @games = Game.where('black_player_id = ? OR white_player_id = ?', @user.id, @user.id)
    if @user != current_user
      return render :text => 'Not Allowed', :status => :forbidden
    end
  end

  private

  # rubocop:disable Performance/Count
  def games_won?
    @games.select { |game| game.winning_player_id == @user.id }.count
  end

  def games_lost?
    @games.select do |game|
      game.winning_player_id != @user.id && !game.winning_player_id.nil?
    end.count
  end

  def games_draw?
    @games.select { |game| game.winning_player_id == -1 }.count
  end

  def games_unfinished?
    @games.select { |game| game.winning_player_id.nil? }
  end
end
