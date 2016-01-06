module GamesHelper
  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity, Metrics/LineLength
  def piece_present?(pieces, game, row_pos, col_pos)
    white_pieces = {
      'Pawn'   => '&#9817;',
      'Rook'   => '&#9814;',
      'Knight' => '&#9816;',
      'Bishop' => '&#9815;',
      'Queen'  => '&#9813;',
      'King' => '&#9812;'
    }

    black_pieces = {
      'Pawn'   => '&#9823;',
      'Rook'   => '&#9820;',
      'Knight' => '&#9822;',
      'Bishop' => '&#9821;',
      'Queen'  => '&#9819;',
      'King' => '&#9818;'
    }

    @piece = pieces.find_by(row_position: row_pos, col_position: col_pos)
    if @piece && @piece.user_id == game.white_player_id
      return content_tag(:span, white_pieces[@piece.type].html_safe, class: %w(piece move_mode), pos: "#{row_pos}#{col_pos}", id: "#{@piece.id}") if current_user.id == game.white_player_id && game.whos_turn? == game.white_player_id
      return content_tag(:span, white_pieces[@piece.type].html_safe, class: ["piece"], pos: "#{row_pos}#{col_pos}", id: "#{@piece.id}")
    elsif @piece && @piece.user_id == @game.black_player_id
      return content_tag(:span, black_pieces[@piece.type].html_safe, class: %w(piece move_mode), pos: "#{row_pos}#{col_pos}", id: "#{@piece.id}") if current_user.id == game.black_player_id && game.whos_turn? == game.black_player_id
      return content_tag(:span, black_pieces[@piece.type].html_safe, class: ["piece"], pos: "#{row_pos}#{col_pos}", id: "#{@piece.id}")
    else
      return tag(:span, class: ["piece"], pos: "#{row_pos}#{col_pos}")
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
    "Black Player's Turn" if @game.whos_turn? == @game.black_player_id
  end

  def my_turn?(game)
    return "<strong>Its your turn!</strong>".html_safe if current_user.id == game.whos_turn?
    "Its your opponent's turn"
  end

  def in_check
    return "White: Check" if @game.determine_check && @game.whos_turn? == @game.white_player_id
    return "Black: Check" if @game.determine_check && @game.whos_turn? == @game.black_player_id
  end

  def winning_player
    return true unless @game.winning_player_id.nil?
    false
  end
end
