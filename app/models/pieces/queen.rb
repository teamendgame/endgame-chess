class Queen < Piece
  # rubocop:disable Metrics/LineLength
  def valid_move?(row_dest, col_dest)
    # checking whether the move is horizontal, diagonal or vertical
    if !horizontal_move?(row_dest, col_dest) && !vertical_move?(row_dest, col_dest) && !diagonal_move?(row_dest, col_dest)
      return false
    # checking for obstruction
    elsif obstructed?(row_dest, col_dest)
      return false
    # checking if a piece from the same color is there
    else
      return !self.own_piece?(row_dest, col_dest)
    end
  end
end
