class King < Piece
  def valid_move?(row_dest, col_dest)
    row_pos = row_position
    col_pos = col_position
    current_user = user_id
    row_diff = (row_pos - row_dest).abs
    col_diff = (col_pos - col_dest).abs
    # checking weather the move is longer than one step to any direction
    if row_diff > 1 || col_diff > 1
      return false
    else
      # king is inside destination. checking if a piece from the same color is there.
      return game.pieces.find_by(row_position: row_dest, col_position: col_dest, user_id: current_user).nil?
    end
  end
end
