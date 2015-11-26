class Piece < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  def move_to!(new_row, new_col)
    @piece = Piece.find_by(row_position: new_row, col_position: new_col)
    if @piece
      if @piece.user_id != user_id
        @piece.update(row_position: nil, col_position: nil, captured: true)
        update(row_position: new_row, col_position: new_col)
      end
    else
      update(row_position: new_row, col_position: new_col)
    end
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
  def own_piece?(row_dest, col_dest)
    true if game.pieces.find_by(row_position: row_dest, col_position: col_dest, user_id: user_id)
  end

  # rubocop:disable Metrics/LineLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
  def obstructed?(row_dest, col_dest)
    # pass in row and col destination
    # get the current piece position
    # work out if the move is horizontal or diagonal or vertical
    # if is check obstruction
    # this method is not checking destinations outside of the board
    # because the players should not be able to select a destination outside of the board
    # if knight return an error

    row_pos = row_position
    col_pos = col_position

    return "Invalid input! Knight can't be obstructed." if type == "Knight"

    if col_pos == col_dest # this is checking vertical obstruction
      if row_pos < row_dest
        # find out which is higher to create a range and return pieces within that range
        row_pos += 1
        return !game.pieces.find_by(captured: false, row_position: [row_pos...row_dest], col_position: col_pos).nil?
      else
        row_dest += 1
        return !game.pieces.find_by(captured: false, row_position: [row_dest...row_pos], col_position: col_pos).nil?
      end
    elsif row_pos == row_dest # this is checking horizontal obstruction
      if col_pos < col_dest
        col_pos += 1
        col_dest -= 1
        return !game.pieces.find_by(captured: false, row_position: row_pos, col_position: [col_pos..col_dest]).nil?
      else
        col_pos -= 1
        col_dest += 1
        return !game.pieces.find_by(captured: false, row_position: row_pos, col_position: [col_dest..col_pos]).nil?
      end
    elsif (col_pos - col_dest).abs == (row_pos - row_dest).abs # is checking diagonal obstruction
      # check each row/col combo 1 by 1
      # row and col both increase
      if row_pos < row_dest && col_pos < col_dest
        row_pos += 1
        (row_pos...row_dest).each do |row_num|
          col_pos += 1
          return !game.pieces.find_by(captured: false, row_position: row_num, col_position: col_pos).nil?
        end
      # row and col both decrease
      elsif row_pos > row_dest && col_pos > col_dest
        row_dest += 1
        (row_dest...row_pos).each do |row_num|
          col_dest += 1
          return !game.pieces.find_by(captured: false, row_position: row_num, col_position: col_dest).nil?
        end
      # row increases col decreases
      elsif row_pos < row_dest && col_pos > col_dest
        row_pos += 1
        (row_pos...row_dest).each do |row_num|
          col_pos -= 1
          return !game.pieces.find_by(captured: false, row_position: row_num, col_position: col_pos).nil?
        end
      # row decreases col increases
      else
        row_dest += 1
        (row_dest...row_pos).each do |row_num|
          col_dest -= 1
          return !game.pieces.where(captured: false, row_position: row_num, col_position: col_dest).nil?
        end
      end
    else
      return "ERROR! in is_obstructed? method line:83"
    end
  end
end
