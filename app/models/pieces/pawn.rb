class Pawn < Piece
  after_update :update_previous_changes

  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/LineLength
  def valid_move?(row_dest, col_dest)
    @adjacent_piece_r = Piece.find_by(row_position: row_position, col_position: col_position + 1)
    @adjacent_piece_l = Piece.find_by(row_position: row_position, col_position: col_position - 1)
    @last_updated = Piece.where(game_id: game_id).order("updated_at desc").first
    if @adjacent_piece_r && @adjacent_piece_r.type == "Pawn"
      return true if check_en_passant(row_dest, col_dest, @adjacent_piece_r, @last_updated)
    elsif @adjacent_piece_l && @adjacent_piece_l.type = "Pawn"
      return true if check_en_passant(row_dest, col_dest, @adjacent_piece_l, @last_updated)
    end
    row_diff = (row_position - row_dest).abs
    col_diff = (col_position - col_dest).abs
    return false if self.backward_move?(row_dest, col_dest) || self.horizontal_move?(row_dest, col_dest)
    return true if self.diagonal_move?(row_dest, col_dest) && col_diff == 1 && row_diff == 1 && game.pieces.find_by(row_position: row_dest, col_position: col_dest) && !self.own_piece?(row_dest, col_dest)
    if self.vertical_move?(row_dest, col_dest) && !game.pieces.find_by(row_position: row_dest, col_position: col_dest)
      return false if row_diff > 2
      return true if row_position == 1 || row_position == 6 && row_diff <= 2
      return true if row_diff == 1
    end
    false
  end

  def backward_move?(row_dest, _col_dest)
    user_id == game.white_player_id ? row_position > row_dest : row_position < row_dest
  end

  private

  def update_previous_changes
    update_column(:previous_changes_hash, changes)
  end
end
