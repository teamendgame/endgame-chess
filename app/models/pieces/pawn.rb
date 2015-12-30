class Pawn < Piece
  after_save :update_previous_changes

  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/LineLength, Metrics/PerceivedComplexity, Metrics/MethodLength
  def valid_move?(row_dest, col_dest)
    return true if check_adjacent_pieces(row_dest, col_dest)
    row_diff = (row_position - row_dest).abs
    col_diff = (col_position - col_dest).abs
    return false if self.backward_move?(row_dest, col_dest) || self.horizontal_move?(row_dest, col_dest)
    return true if self.diagonal_move?(row_dest, col_dest) && col_diff == 1 && row_diff == 1 && game.pieces.find_by(row_position: row_dest, col_position: col_dest) && !self.own_piece?(row_dest, col_dest)
    return false unless self.vertical_move?(row_dest, col_dest) && !game.pieces.find_by(row_position: row_dest, col_position: col_dest)
    return false if row_diff > 2
    return true if row_position == 1 || row_position == 6 && row_diff <= 2 || row_diff == 1
  end

  def check_adjacent_pieces(new_row, new_col)
    @last_updated = Piece.where(game_id: game_id).order("updated_at desc").first
    @adjacent_piece_r = Piece.find_by(row_position: row_position, col_position: col_position + 1) if col_position != 7
    @adjacent_piece_l = Piece.find_by(row_position: row_position, col_position: col_position - 1) if col_position != 0
    if @adjacent_piece_l && @adjacent_piece_l.type == "Pawn" && @last_updated == @adjacent_piece_l
      return true if check_en_passant(new_row, new_col, @last_updated)
    elsif @adjacent_piece_r && @adjacent_piece_r.type == "Pawn" && @last_updated == @adjacent_piece_r
      return true if check_en_passant(new_row, new_col, @last_updated)
    end
  end

  # Public: Check pawn for en passant
  #
  # row_dest, col_dest - destination coordinates
  # adjacent_pawn - pawn next to Piece (also last updated Piece)
  # last_updated - last updated Model
  #
  # Check if last updated Piece has relevant previous changes.
  # Get the row_position of last updated and check if it had been moved.
  # If the last move consisted of moving 2 rows and it had not been moved yet,
  # the pawn can conduct an en passant
  # and returns true, else false
  def check_en_passant(row_dest, col_dest, last_updated)
    return false if last_updated.prev_changes.nil?
    return false if last_updated.prev_changes["moved"].nil? || last_updated.prev_changes["row_position"].nil?
    # Convert string array stored in prev_changes into array
    # rubocop:disable Lint/Eval
    @last_updated_row = eval(last_updated.prev_changes["row_position"].gsub(/(\w+?)/, "'\\1'"))
    @last_updated_moved = eval(last_updated.prev_changes["moved"].gsub(/(\w+?)/, "'\\1'"))
    return false unless (@last_updated_row[0].to_i - @last_updated_row[1].to_i).abs == 2 && @last_updated_moved
    if Game.find(game_id).black_player_id == user_id
      return true if row_dest == last_updated.row_position - 1 && col_dest == last_updated.col_position
    else
      return true if row_dest == last_updated.row_position + 1 && col_dest == last_updated.col_position
    end
  end

  def capture_en_passant!(row_dest, col_dest)
    @last_updated = Piece.where(game_id: game_id).order("updated_at desc").first
    # check player color and capture accordingly
    if Game.find(game_id).black_player_id == user_id
      if row_dest == @last_updated.row_position - 1 && col_dest == @last_updated.col_position
        @last_updated.update(row_position: nil, col_position: nil, captured: true)
        update(row_position: row_dest, col_position: col_dest, moved: true)
      end
    else
      if row_dest == @last_updated.row_position + 1 && col_dest == @last_updated.col_position
        @last_updated.update(row_position: nil, col_position: nil, captured: true)
        update(row_position: row_dest, col_position: col_dest, moved: true)
      end
    end
    true
  end

  def backward_move?(row_dest, _col_dest)
    user_id == game.white_player_id ? row_position > row_dest : row_position < row_dest
  end

  private

  def update_previous_changes
    update_column(:prev_changes, changes)
  end
end
