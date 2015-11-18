class Piece < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  def is_obstructed?(row_dest, col_dest)
  	# pass in row and col destination
  	# get the current piece position
  	# work out if the move is horizontal or diagonal or vertical
  	# if is check obstruction


  	row_pos = self.row_position
  	col_pos = self.col_position
  	current_user = self.user_id



  	if col_pos == col_dest # this means move is vertical


  		# return self.game.pieces.where(row_position: 6, col_position: 7).first


  		return "vertical move"
  	elsif row_pos == row_dest



  		return self.game.pieces.where(row_position: 7, col_position: 5)


  		# return "horizontal move"
  	elsif (col_pos - col_dest).abs == (row_pos - row_dest).abs
  		return "diagonal move"
  	else
  		return "else"
  	end



  	return "Bla bla bla"
  end
  
end