module GamesHelper
  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity, Metrics/LineLength
  def piece_present?(pieces, game, row_pos, col_pos)
    @piece = pieces.find_by(row_position: row_pos, col_position: col_pos)
    if @piece && @piece.user_id == game.white_player_id
      case @piece.type
      when "Pawn"
        white_pawn(@piece, game)
      when "Rook"
        white_rook(@piece, game)
      when "Knight"
        white_knight(@piece, game)
      when "Bishop"
        white_bishop(@piece, game)
      when "Queen"
        white_queen(@piece, game)
      when "King"
        white_king(@piece, game)
      end
    elsif @piece && @piece.user_id == @game.black_player_id
      case @piece.type
      when "Pawn"
        black_pawn(@piece, game)
      when "Rook"
        black_rook(@piece, game)
      when "Knight"
        black_knight(@piece, game)
      when "Bishop"
        black_bishop(@piece, game)
      when "Queen"
        black_queen(@piece, game)
      when "King"
        black_king(@piece, game)
      end
    end
  end

  def black_player
    return "Black Player: You" if current_user.id == @game.black_player_id
    "Black Player: Your Opponent"
  end

  def white_player
    return "White Player: You" if current_user.id == @game.white_player_id
    "White Player: Your Opponent"
  end

  def turn
    return "White Player's Turn" if @game.whos_turn? == @game.white_player_id
    return "White Player's Turn" if @game.whos_turn? == @game.black_player_id
  end

  private

  def white_pawn(piece, game)
    return link_to '&#9817;'.html_safe, piece_path(piece.id) if current_user.id == game.white_player_id
    return '&#9817;'.html_safe if current_user.id == game.black_player_id
  end

  def white_rook(piece, game)
    return link_to '&#9814;'.html_safe, piece_path(piece.id) if current_user.id == game.white_player_id
    return '&#9814;'.html_safe if current_user.id == game.black_player_id
  end

  def white_knight(piece, game)
    return link_to '&#9816;'.html_safe, piece_path(piece.id) if current_user.id == game.white_player_id
    return '&#9816;'.html_safe if current_user.id == game.black_player_id
  end

  def white_bishop(piece, game)
    return link_to '&#9815;'.html_safe, piece_path(piece.id) if current_user.id == game.white_player_id
    return '&#9815;'.html_safe if current_user.id == game.black_player_id
  end

  def white_queen(piece, game)
    return link_to '&#9812;'.html_safe, piece_path(piece.id) if current_user.id == game.white_player_id
    return '&#9812;'.html_safe if current_user.id == game.black_player_id
  end

  def white_king(piece, game)
    return link_to '&#9813;'.html_safe, piece_path(piece.id) if current_user.id == game.white_player_id
    return '&#9813;'.html_safe if current_user.id == game.black_player_id
  end

  def black_pawn(piece, game)
    return link_to '&#9823;'.html_safe, piece_path(piece.id) if current_user.id == game.black_player_id
    return '&#9823;'.html_safe if current_user.id == game.white_player_id
  end

  def black_rook(piece, game)
    return link_to '&#9820;'.html_safe, piece_path(piece.id) if current_user.id == game.black_player_id
    return '&#9820;'.html_safe if current_user.id == game.white_player_id
  end

  def black_knight(piece, game)
    return link_to '&#9822;'.html_safe, piece_path(piece.id) if current_user.id == game.black_player_id
    return '&#9822;'.html_safe if current_user.id == game.white_player_id
  end

  def black_bishop(piece, game)
    return link_to '&#9821;'.html_safe, piece_path(piece.id) if current_user.id == game.black_player_id
    return '&#9821;'.html_safe if current_user.id == game.white_player_id
  end

  def black_queen(piece, game)
    return link_to '&#9818;'.html_safe, piece_path(piece.id) if current_user.id == game.black_player_id
    return '&#9818;'.html_safe if current_user.id == game.white_player_id
  end

  def black_king(piece, game)
    return link_to '&#9819;'.html_safe, piece_path(piece.id) if current_user.id == game.black_player_id
    return '&#9819;'.html_safe if current_user.id == game.white_player_id
  end
end
