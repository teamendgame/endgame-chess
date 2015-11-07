class CreatePieces < ActiveRecord::Migration
  def change
    create_table :pieces do |t|

      t.string :type
      t.string :color
      t.integer :row_position
      t.integer :col_position
      t.integer :game_player_id
      t.boolean :captured	

      t.timestamps null: false
    end
  end
end
