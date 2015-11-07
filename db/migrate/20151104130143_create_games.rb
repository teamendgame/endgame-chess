class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|

      t.string :name
      t.string :state
      t.integer :turn_number
      t.table :game_players


      t.timestamps null: false
    end
  end
end
