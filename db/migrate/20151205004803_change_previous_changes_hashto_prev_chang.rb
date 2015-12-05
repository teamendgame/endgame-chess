class ChangePreviousChangesHashtoPrevChang < ActiveRecord::Migration
  def change
  	rename_column :pieces, :previous_changes_hash, :prev_changes
  end
end
