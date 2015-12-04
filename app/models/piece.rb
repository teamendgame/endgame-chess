class Piece < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  # Validate move of en passant
  # Move_to! if piece is next to a pawn and the piece is a pawn
  # check if en passant is possible

  def move_to!(new_row, new_col)
    @piece = Piece.find_by(row_position: new_row, col_position: new_col)
    @adjacent_piece_r = Piece.find_by(row_position: row_position, col_position: col_position + 1) if col_position != 7
    @adjacent_piece_l = Piece.find_by(row_position: row_position, col_position: col_position - 1) if col_position != 0
    @last_updated = Piece.where(game_id: game_id).order("updated_at desc").first
    if type == "Pawn" && @adjacent_piece_r && @adjacent_piece_r.type == "Pawn" && !@piece
      capture_en_passant(new_row, new_col, @adjacent_piece_r, @last_updated) if check_en_passant(new_row, new_col, @adjacent_piece_r, @last_updated)
    elsif type == "Pawn" && @adjacent_piece_l && @adjacent_piece_r.type == "Pawn" && !@piece
      capture_en_passant(new_row, new_col, @adjacent_piece_l, @last_updated) if check_en_passant(new_row, new_col, @adjacent_piece_l, @last_updated)
    end
    update(row_position: new_row, col_position: new_col, moved: true) && return unless @piece
    if @piece.user_id != user_id
      @piece.update(row_position: nil, col_position: nil, captured: true)
      update(row_position: new_row, col_position: new_col, moved: true)
    else
      check_if_castling(new_row, new_col)
    end
  end

  def check_en_passant(row_dest, col_dest, adjacent_pawn, last_updated)
    return false if last_updated == adjacent_pawn || last_updated.previous_changes_hash.nil? || last_updated.previous_changes_hash["moved"].nil? || last_updated.previous_changes_hash["row_position"].nil?
    @last_updated_row = last_updated.previous_changes_hash["row_position"]
    @last_updated_moved = last_updated.previous_changes_hash["moved"][0]
    return unless (@last_updated_row[0].to_i - @last_updated_row[1].to_i).abs == 2 && @last_updated_moved
    valid_move_black = Game.find(game_id).black_player_id == user_id && row_dest == last_updated.row_position - 1 && col_dest == last_updated.col_position
    valid_move_white = Game.find(game_id).black_player_id != user_id && row_dest == last_updated.row_position + 1 && col_dest == last_updated.col_position
    return true if valid_move_black
    return true if valid_move_white
    false
  end

  def capture_en_passant(row_dest, col_dest, adjacent_piece, last_updated)
    if Game.find(game_id).black_player_id == user_id && row_dest == (last_updated.row_position - 1) && col_dest == last_updated.col_position
      last_updated.update(row_position: nil, col_position: nil, captured: true)
      update(row_position: row_dest, col_position: col_dest, moved: true)
    elsif Game.find(game_id).black_player_id != user_id && row_dest == (last_updated.row_position + 1) && col_dest == last_updated.col_position
      last_updated.update(row_position: nil, col_position: nil, captured: true)
      update(row_position: row_dest, col_position: col_dest, moved: true)
    end
  end

  def check_if_castling(row, col)
    @piece = Piece.find_by(row_position: row, col_position: col)
    return unless @piece && type == "King" && !moved && @piece.type == "Rook" && !@piece.moved
    can_castle?(row, col)
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
          return !game.pieces.find_by(captured: false, row_position: row_num, col_position: col_dest).nil?
        end
      end
    else
      return "ERROR! in is_obstructed? method line:83"
    end
  end
end
