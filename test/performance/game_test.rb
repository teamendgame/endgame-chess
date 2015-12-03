require 'test_helper'
require 'rails/performance_test_help'

class GamePerformanceTest < ActionDispatch::PerformanceTest
  # Refer to the documentation for all available options
  self.profile_options = { runs: 10, metrics: [:wall_time, :cpu_time],
                           output: 'tmp/performance', formats: [:flat] }
  def setup
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @g = Game.create(name: "New Game", white_player_id: @user1.id, black_player_id: @user2.id, turn_number: 1) # rubocop:disable Metrics/LineLength
    @g.populate_board!
    @g.pieces.where(type: "Rook").destroy_all
    @g.pieces.where(type: "Pawn").destroy_all
  end

  test "determine_check" do
    @g.determine_check
  end

  test "determine_check_2" do
    @g.determine_check_2
  end
end
