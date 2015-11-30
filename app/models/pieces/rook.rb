class Rook < Piece
  def valid_move?(row_dest, col_dest)
    # Rook can only move horizontally and vertically
    if self.horizontal_move?(row_dest, col_dest) || self.vertical_move?(row_dest, col_dest)
      # return !own_piece?(row_dest, col_dest)
      # return !obstructed?(row_dest, col_dest)
      if !self.obstructed?(row_dest, col_dest) #&& !own_piece?(row_dest, col_dest) # own_piece? method should only checked uncaptured pieces!?
        "can't get here for some reason"
      else
        "and can't get here EITHER!?"
      end
      return "what is this scenario!?"
    else
      false
    end
  end



  # def valid_move?(row_dest, col_dest)
  #   # Rook can only move horizontally and vertically
  #   if self.horizontal_move?(row_dest, col_dest) || self.vertical_move?(row_dest, col_dest) && !self.obstructed?(row_dest, col_dest) && !self.own_piece?(row_dest, col_dest) # own_piece? method should only checked uncaptured pieces!?
  #     return true
  #   else
  #     return false
  #   end
  # end



end
