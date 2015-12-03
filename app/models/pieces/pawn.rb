class Pawn < Piece
  # rubocop:disable Metrics/LineLength 
  def valid_move?(row_dest, col_dest)
  	row_diff = (row_position - row_dest).abs
    col_diff = (col_position - col_dest).abs
    return false if self.backward_move?(row_dest, col_dest) || self.horizontal_move?(row_dest, col_dest)
    return true if self.diagonal_move?(row_dest, col_dest) &&  col_diff == 1 && row_diff == 1 && game.pieces.find_by(row_position: row_dest, col_position: col_dest) && !self.own_piece?(row_dest, col_dest)
  	if self.vertical_move?(row_dest, col_dest) && !game.pieces.find_by(row_position: row_dest, col_position: col_dest) 
  	  return false if row_diff > 2
  	  return true if row_position == 1 || row_position == 6 && row_diff <= 2
 	  return true if row_diff == 1
   	end 	
    return false
  end

  def backward_move?(row_dest, col_dest)
  	self.user_id == self.game.white_player_id ? row_position > row_dest : row_position < row_dest
  end
end



