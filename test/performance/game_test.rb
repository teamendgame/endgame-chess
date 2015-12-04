require 'test_helper'
require 'rails/performance_test_help'

class GamePerformanceTest < ActionDispatch::PerformanceTest
  # Refer to the documentation for all available options
  self.profile_options = { runs: 10, metrics: [:wall_time, :cpu_time],
                           output: 'tmp/performance', formats: [:flat] }
  # rubocop:disable Metrics/LineLength
  # def setup
  #   @user1 = FactoryGirl.create(:user)
  #   @user2 = FactoryGirl.create(:user)
  #   @g = Game.create(name: "New Game", white_player_id: @user1.id, black_player_id: @user2.id, turn_number: 1)
  #   @g.populate_board!
  # end
end
