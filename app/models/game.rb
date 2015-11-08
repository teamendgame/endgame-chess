class Game < ActiveRecord::Base
  has_many :pieces
  belongs_to :user

  after_create :populate_board!
  
  def populate_board!
    init_pawn
    init_rook
    init_knight
    init_bishop
    init_queen
    init_king
  end

  def init_pawn
    7.downto(0) do |col|
      self.pieces.create(type: "Pawn", col_position: col, row_position: 1)
      self.pieces.create(type: "Pawn", col_position: col, row_position: 6)
    end
  end

  def init_rook
    self.pieces.create(type: "Rook", col_position: 0, row_position: 0)
    self.pieces.create(type: "Rook", col_position: 7, row_position: 0)
    self.pieces.create(type: "Rook", col_position: 0, row_position: 7)
    self.pieces.create(type: "Rook", col_position: 7, row_position: 7)
  end 

  def init_knight
    self.pieces.create(type: "Knight", col_position: 1, row_position: 0)
    self.pieces.create(type: "Knight", col_position: 6, row_position: 0)
    self.pieces.create(type: "Knight", col_position: 1, row_position: 7)
    self.pieces.create(type: "Knight", col_position: 6, row_position: 7)
  end

  def init_bishop
    self.pieces.create(type: "Bishop", col_position: 2, row_position: 0)
    self.pieces.create(type: "Bishop", col_position: 5, row_position: 0)
    self.pieces.create(type: "Bishop", col_position: 2, row_position: 7)
    self.pieces.create(type: "Bishop", col_position: 5, row_position: 7)
  end

  def init_queen
    self.pieces.create(type: "Queen", col_position: 3, row_position: 0)
    self.pieces.create(type: "Queen", col_position: 3, row_position: 7)
  end

  def init_king
    self.pieces.create(type: "King", col_position: 4, row_position: 0)
    self.pieces.create(type: "King", col_position: 4, row_position: 7)
  end
end
