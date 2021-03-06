# rubocop:disable Metrics/ClassLength
class Piece < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  def move_to!(new_row, new_col)
    Piece.transaction do
      moved = try_to_move(new_row, new_col)
      in_check = game.determine_check
      return moved unless in_check
      fail ActiveRecord::Rollback
    end
    false
  end

  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/LineLength
  def try_to_move(new_row, new_col)
    piece = Piece.find_by(row_position: new_row, col_position: new_col, game_id: game_id)
    # Execute En Passant if conditions are right
    capture_en_passant!(new_row, new_col) if type == "Pawn" && check_adjacent_pieces(new_row, new_col)
    # Execute castling procedures if piece is King
    return true if type == "King" && castling(new_row, new_col)
    # Checking for Valid Move
    return false unless valid_move?(new_row, new_col)
    # If there is not a piece in the destination,
    # move to that location
    return move!(new_row, new_col) unless piece
    # If there is a piece in the destination,
    # capture it and move to that location
    capture!(piece, new_row, new_col)
  end

  def horizontal_move?(row_dest, _col_dest)
    row_position == row_dest
  end

  def vertical_move?(_row_dest, col_dest)
    col_position == col_dest
  end

  def diagonal_move?(row_dest, col_dest)
    row_diff = (row_position - row_dest).abs
    col_diff = (col_position - col_dest).abs
    row_diff == col_diff
  end

  # Returns true if piece in destination already belongs to you
  # else returns false
  def own_piece?(row_dest, col_dest)
    return true if game.pieces.find_by(row_position: row_dest, col_position: col_dest, user_id: user_id)
    false
  end

  def obstructed?(row_dest, col_dest)
    return false if type == "Knight"
    return vertical_obstruction(row_dest) if vertical_move?(row_dest, col_dest)
    return horizontal_obstruction(col_dest) if horizontal_move?(row_dest, col_dest)
    return diagonal_obstruction(row_dest, col_dest) if diagonal_move?(row_dest, col_dest)
  end

  private

  def move!(new_row, new_col)
    update(row_position: new_row, col_position: new_col, moved: true)
    true
  end

  def capture!(piece, new_row, new_col)
    return false unless piece.user_id != user_id
    piece.update(row_position: nil, col_position: nil, captured: true)
    update(row_position: new_row, col_position: new_col, moved: true)
    true
  end

  def castling(new_row, new_col)
    return false unless check_if_castling?(new_row, new_col)
    return false unless can_castle?(new_row, new_col)
    castle!(new_row, new_col)
    true
  end

  def check_if_castling?(row, col)
    piece = Piece.find_by(row_position: row, col_position: col, game_id: game_id, user_id: user_id)
    return false unless piece && type == "King" && !moved && piece.type == "Rook" && !piece.moved
    true
  end

  def vertical_obstruction(row_dest)
    row_pos = row_position
    if row_pos < row_dest
      # find out which is higher to create a range and return pieces within that range
      row_pos += 1
      return true unless game.pieces.find_by(row_position: [row_pos...row_dest], col_position: col_position).nil?
    else
      row_dest += 1
      return true unless game.pieces.find_by(row_position: [row_dest...row_pos], col_position: col_position).nil?
    end
    false
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def horizontal_obstruction(col_dest)
    col_pos = col_position
    if col_pos < col_dest
      col_pos += 1
      col_dest -= 1
      return true unless game.pieces.find_by(row_position: row_position, col_position: [col_pos..col_dest]).nil?
    else
      col_pos -= 1
      col_dest += 1
      return true unless game.pieces.find_by(row_position: row_position, col_position: [col_dest..col_pos]).nil?
    end
    false
  end

  # rubocop:disable Metrics/PerceivedComplexity
  def diagonal_obstruction(row_dest, col_dest)
    row_pos = row_position
    col_pos = col_position

    # check each row/col combo 1 by 1
    # row and col both increase
    if row_pos < row_dest && col_pos < col_dest
      row_pos += 1
      (row_pos...row_dest).each do |row_num|
        col_pos += 1
        return true unless game.pieces.find_by(row_position: row_num, col_position: col_pos).nil?
      end
    # row and col both decrease
    elsif row_pos > row_dest && col_pos > col_dest
      row_dest += 1
      (row_dest...row_pos).each do |row_num|
        col_dest += 1
        return true unless game.pieces.find_by(row_position: row_num, col_position: col_dest).nil?
      end
    # row increases col decreases
    elsif row_pos < row_dest && col_pos > col_dest
      row_pos += 1
      (row_pos...row_dest).each do |row_num|
        col_pos -= 1
        return true unless game.pieces.find_by(row_position: row_num, col_position: col_pos).nil?
      end
    # row decreases col increases
    else
      row_dest += 1
      (row_dest...row_pos).each do |row_num|
        col_dest -= 1
        return true unless game.pieces.find_by(row_position: row_num, col_position: col_dest).nil?
      end
    end
    false
  end
end
