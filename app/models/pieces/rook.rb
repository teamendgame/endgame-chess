class Rook < Piece
  def valid_move?(row_dest, col_dest)
    # Rook can only move horizontally and vertically
    # rubocop:disable Metrics/LineLength
    if horizontal_move?(row_dest, col_dest) || vertical_move?(row_dest, col_dest) && !obstructed?(row_dest, col_dest) && !own_piece?(row_dest, col_dest)
      return true
    else
      return false
    end
  end
end
