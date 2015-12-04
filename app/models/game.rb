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

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def determine_check
    if turn_number.even?
      opponent_pieces = pieces.where(user_id: black_player_id)
      king = pieces.find_by(user_id: white_player_id, type: "King")
      opponent_pieces.each do |piece|
        return true if piece.valid_move?(king.row_position, king.col_position)
      end
    else
      opponent_pieces = pieces.where(user_id: white_player_id)
      king = pieces.find_by(user_id: black_player_id, type: "King")
      opponent_pieces.each do |piece|
        return true if piece.valid_move?(king.row_position, king.col_position)
      end
    end
    false
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
