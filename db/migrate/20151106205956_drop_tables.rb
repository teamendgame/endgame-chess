class DropTables < ActiveRecord::Migration
  def up
    drop_table :players
    drop_table :game_players
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

end
