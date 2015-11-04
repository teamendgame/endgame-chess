class CreatePieces < ActiveRecord::Migration
  def change
    create_table :pieces do |t|

      t.timestamps null: false
    end
  end
end
