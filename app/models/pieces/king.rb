class King < Piece
  def can_castle?(rook_row, rook_col)
    rook = Rook.find_by(row_position: rook_row, col_position: rook_col)
    return false if moved || rook.moved || obstructed?(rook_row, rook_col)
    true
  end

  def kingside?(rook_col)
    rook_col - col_position == 3 ? true : false
  end

  def castle!(new_row, new_col)
    rook = Rook.find_by(row_position: new_row, col_position: new_col)
    rook_col = rook.col_position
    if kingside?(rook_col)
      update(col_position: rook_col - 1, moved: true)
      rook.update(col_position: rook_col - 2, moved: true)
    else
      update(col_position: rook_col + 2, moved: true)
      rook.update(col_position: rook_col + 3, moved: true)
    end
  end

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
