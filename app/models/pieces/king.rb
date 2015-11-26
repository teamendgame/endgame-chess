class King < Piece
  def valid_move?(row_dest, col_dest)
    row_diff = (row_position - row_dest).abs
    col_diff = (col_position - col_dest).abs
    # checking whether the move is longer than one step to any direction
    if row_diff > 1 || col_diff > 1
      return false
    else
      # king is inside destination. checking if a piece from the same color is there.
      !self.own_piece?(row_dest, col_dest)
    end
  end
end
