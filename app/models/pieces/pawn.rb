class Pawn < Piece
  after_update :update_previous_changes

  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/LineLength
  def valid_move?(row_dest, col_dest)
    check_en_passant(row_dest, col_dest)
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

  def check_en_passant(row_dest, col_dest)
    @last_updated = Piece.where(game_id: game_id).order("updated_at desc").first
    return if @last_updated.nil? || @last_updated.type != "Pawn" || @last_updated.previous_changes_hash.nil?
    return if @last_updated.previous_changes_hash["moved"].nil? || @last_updated.previous_changes_hash["row_position"].nil?
    @last_updated_row = @last_updated.previous_changes_hash["row_position"]
    @last_updated_moved = @last_updated.previous_changes_hash["moved"][0]
    return unless @last_updated.col_position == col_position + 1 || col_position - 1
    return unless (@last_updated_row[0].to_i - @last_updated_row[1].to_i).abs == 2 && @last_updated_moved
    valid_move_black = Game.find(game_id).black_player_id == user_id && row_dest == @last_updated.row_position - 1 && col_dest == @last_updated.col_position
    valid_move_white = Game.find(game_id).black_player_id != user_id && row_dest == @last_updated.row_position + 1 && col_dest == @last_updated.col_position
    valid_move_black || valid_move_white ? true : false
  end

  private

  def update_previous_changes
    update_column(:previous_changes_hash, changes)
  end
end
