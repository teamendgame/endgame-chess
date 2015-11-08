class AddIndices < ActiveRecord::Migration
  def change
    add_index :games, [:white_player_id, :black_player_id]
    add_index :pieces, [:game_id, :user_id]
  end
end
