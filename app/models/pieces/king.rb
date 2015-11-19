class King < Piece
  def valid_move?(row_dest, col_dest)
    row_diff = (row_position - row_dest).abs
    col_diff = (col_position - col_dest).abs
    # checking weather the move is longer than one step to any direction
    if row_diff > 1 || col_diff > 1
      return false
    else
      # king is inside destination. checking if a piece from the same color is there.
      # rubocop:disable Metrics/LineLength
      return game.pieces.find_by(row_position: row_dest, col_position: col_dest, user_id: user_id).nil?
    end
  end
end
