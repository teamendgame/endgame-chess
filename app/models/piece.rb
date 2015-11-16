class Piece < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  def move_to!(new_row, new_col)
  	@piece = Piece.find_by(row_position: new_row, col_position: new_col)
  	if @piece
	    if @piece.user_id != self.user_id
				@piece.update(row_position: nil, col_position: nil, captured: true)
				self.update(row_position: new_row, col_position: new_col)
      end
	  else
  	  self.update(row_position: new_row, col_position: new_col)
  	end
  end

end
