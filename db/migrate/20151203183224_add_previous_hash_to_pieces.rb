class AddPreviousHashToPieces < ActiveRecord::Migration
  def change
  	enable_extension "hstore"
  	add_column :pieces, :previous_changes_hash, :hstore
  end
end
