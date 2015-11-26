class Knight < Piece
  def valid_move?(row_dest, col_dest)
    vertical = (row_position - row_dest).abs
    horizontal = (col_position - col_dest).abs
    return false if self.own_piece?(row_dest, col_dest) || (vertical + horizontal) != 3
    true
  end
end
