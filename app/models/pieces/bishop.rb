class Bishop < Piece
  def valid_move?(row_dest, col_dest)
    # Bishop can only move diagonally
    # rubocop:disable Metrics/LineLength
    return false if !self.diagonal_move?(row_dest, col_dest) || self.own_piece?(row_dest, col_dest) || self.obstructed?(row_dest, col_dest)
    true
  end
end
