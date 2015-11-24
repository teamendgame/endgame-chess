class Piece < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  def is_obstructed?(row_dest, col_dest)
  	# pass in row and col destination
  	# get the current piece position
  	# work out if the move is horizontal or diagonal or vertical
  	# if is check obstruction
    # this method is not checking destinations outside of the board
    # because the players should not be able to select a destination outside of the board

  	row_pos = self.row_position
  	col_pos = self.col_position
  	current_user = self.user_id

  	if col_pos == col_dest # this is checking vertical obstruction
      if row_pos < row_dest
        # find out which is higher to create a range and return pieces within that range
        row_pos += 1
        return !self.game.pieces.where(row_position: [row_pos...row_dest], col_position: col_pos).first.nil?
      else
        row_dest += 1
        return !self.game.pieces.where(row_position: [row_dest...row_pos], col_position: col_pos).first.nil?
      end
  		return "vertical move"
  	elsif row_pos == row_dest # this is checking horizontal obstruction
      if col_pos < col_dest
        col_pos += 1 
        col_dest -= 1
        return !self.game.pieces.where(row_position: row_pos, col_position: [col_pos..col_dest]).first.nil?
      else
        col_pos -= 1
        col_dest += 1
        return !self.game.pieces.where(row_position: row_pos, col_position: [col_dest..col_pos]).first.nil?
      end
  	elsif (col_pos - col_dest).abs == (row_pos - row_dest).abs # is checking diagonal obstruction
      # check each row/col combo 1 by 1     
      # row and col both increase
      if row_pos < row_dest && col_pos < col_dest
        row_pos += 1
        (row_pos...row_dest).each do |row_num|
          col_pos += 1
          if !self.game.pieces.where(row_position: row_num, col_position: col_pos).first.nil?
            return true
          end
        end
        return false
      # row and col both decrease
      elsif row_pos > row_dest && col_pos > col_dest
        row_dest += 1
        (row_dest...row_pos).each do |row_num|
          col_dest += 1
          if !self.game.pieces.where(row_position: row_num, col_position: col_dest).first.nil?
            return true
          end
        end
        return false
      # row increases col decreases
      elsif row_pos < row_dest && col_pos > col_dest
        row_pos += 1
        (row_pos...row_dest).each do |row_num|
          col_pos -= 1
          if !self.game.pieces.where(row_position: row_num, col_position: col_pos).first.nil?
            return true
          end
        end
        return false
      # row decreases col increases
      else
        row_dest += 1
        (row_dest...row_pos).each do |row_num|
          col_dest -= 1
          if !self.game.pieces.where(row_position: row_num, col_position: col_dest).first.nil?
            return true
          end
        end
        return false
      end
  	else
  		return "ERROR! in is_obstructed? method line:83"
  	end
  end
  
end