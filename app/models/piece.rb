class Piece < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/LineLength, Metrics/MethodLength
  def move_to!(new_row, new_col)
    @piece = Piece.find_by(row_position: new_row, col_position: new_col)
    # Checking for En Passant
    capture_en_passant!(new_row, new_col, @last_updated) && return if type == "Pawn" && check_adjacent_pieces(new_row, new_col)
    # Execute castling procedures if piece is King
    castling(new_row, new_col) if type == "King"
    # Checking for Valid Move
    return unless valid_move?(new_row, new_col)
    # Checking if the piece is moving into check
    return unless !moving_into_check?(new_row, new_col)
    # If there is not a piece in the destination
    update(row_position: new_row, col_position: new_col, moved: true) && return unless @piece
    # Row & col were already updated in moving_into_check? method
    # update(moved: true) && return unless @piece
    # If there is a piece in the destination
    return unless @piece.user_id != user_id
    @piece.update(row_position: nil, col_position: nil, captured: true)
    update(row_position: new_row, col_position: new_col, moved: true)
  end

  def castling(new_row, new_col)
    return unless check_if_castling(new_row, new_col)
    return unless can_castle?(new_row, new_col)
    castle!(new_row, new_col)
  end  

  def moving_into_check?(row_dest, col_dest)
    Piece.transaction do
      # temporarily moving the piece to the new location
      update(row_position: row_dest, col_position: col_dest, moved: true)
      fail ActiveRecord::Rollback if game.determine_check
      false
    end
  end

  def check_if_castling(row, col)
    @piece = Piece.find_by(row_position: row, col_position: col)
    return false unless @piece && type == "King" && !moved && @piece.type == "Rook" && !@piece.moved
    true
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

  def obstructed?(row_dest, col_dest)
    return false if type == "Knight"
    return vertical_obstruction(row_dest) if vertical_move?(row_dest, col_dest)
    return horizontal_obstruction(col_dest) if horizontal_move?(row_dest, col_dest)
    return diagonal_obstruction(row_dest, col_dest) if diagonal_move?(row_dest, col_dest)
  end
end
