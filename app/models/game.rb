class Game < ActiveRecord::Base
  has_many :pieces, dependent: :destroy
  belongs_to :user

  def populate_board!
    init_pawn
    init_rook
    init_knight
    init_bishop
    init_queen
    init_king
  end

  def whos_turn?
    return white_player_id if turn_number.even?
    return black_player_id if turn_number.odd?
  end

  def determine_check
    return check(white_player_id, black_player_id) if turn_number.even?
    check(black_player_id, white_player_id)
  end

  def check(id, opponent_id)
    opponent_pieces = pieces.where(user_id: opponent_id, captured: false)
    king = pieces.find_by(user_id: id, type: "King")
    opponent_pieces.each do |piece|
      return true if piece.valid_move?(king.row_position, king.col_position)
    end
    false
  end

  def determine_checkmate
    return checkmate(white_player_id) if turn_number.even? && determine_check
    return checkmate(black_player_id) if turn_number.odd? && determine_check
    false
  end

  # rubocop:disable Metrics/MethodLength
  def checkmate(id)
    current_pieces = pieces.where(user_id: id, captured: false)
    check_status = true
    current_pieces.each do |piece|
      8.times do |row|
        8.times do |col|
          next unless piece.valid_move?(row, col)
          Piece.transaction do
            piece.try_to_move(row, col)
            check_status = false if determine_check == false
            fail ActiveRecord::Rollback
          end
        end
      end
    end
    check_status
  end

  private

  def init_pawn
    7.downto(0) do |col|
      pieces.create(type: "Pawn", col_position: col, row_position: 1, user_id: white_player_id)
      pieces.create(type: "Pawn", col_position: col, row_position: 6, user_id: black_player_id)
    end
  end

  def init_rook
    pieces.create(type: "Rook", col_position: 0, row_position: 0, user_id: white_player_id)
    pieces.create(type: "Rook", col_position: 7, row_position: 0, user_id: white_player_id)
    pieces.create(type: "Rook", col_position: 0, row_position: 7, user_id: black_player_id)
    pieces.create(type: "Rook", col_position: 7, row_position: 7, user_id: black_player_id)
  end

  def init_knight
    pieces.create(type: "Knight", col_position: 1, row_position: 0, user_id: white_player_id)
    pieces.create(type: "Knight", col_position: 6, row_position: 0, user_id: white_player_id)
    pieces.create(type: "Knight", col_position: 1, row_position: 7, user_id: black_player_id)
    pieces.create(type: "Knight", col_position: 6, row_position: 7, user_id: black_player_id)
  end

  def init_bishop
    pieces.create(type: "Bishop", col_position: 2, row_position: 0, user_id: white_player_id)
    pieces.create(type: "Bishop", col_position: 5, row_position: 0, user_id: white_player_id)
    pieces.create(type: "Bishop", col_position: 2, row_position: 7, user_id: black_player_id)
    pieces.create(type: "Bishop", col_position: 5, row_position: 7, user_id: black_player_id)
  end

  def init_queen
    pieces.create(type: "Queen", col_position: 3, row_position: 0, user_id: white_player_id)
    pieces.create(type: "Queen", col_position: 3, row_position: 7, user_id: black_player_id)
  end

  def init_king
    pieces.create(type: "King", col_position: 4, row_position: 0, user_id: white_player_id)
    pieces.create(type: "King", col_position: 4, row_position: 7, user_id: black_player_id)
  end
end
