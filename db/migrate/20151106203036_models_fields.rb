class ModelsFields < ActiveRecord::Migration
  def change

  	add_column :users, :name, :string
  	

  	add_column :pieces, :type, :string
  	add_column :pieces, :row_position, :integer
  	add_column :pieces, :col_position, :integer
  	add_column :pieces, :game_id, :integer
  	add_column :pieces, :user_id, :integer
  	add_column :pieces, :captured, :boolean

  	add_column :games, :name, :string
  	add_column :games, :white_player_id, :integer
  	add_column :games, :black_player_id, :integer
  	add_column :games, :winning_player_id, :integer
  	add_column :games, :turn_number, :integer
  	
  	
  end
end
