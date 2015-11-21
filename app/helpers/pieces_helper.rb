module PiecesHelper
  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity, Metrics/LineLength
  def selected_piece_present?(game_pieces, row_pos, col_pos)
    @pieces = game_pieces.find_by(row_position: row_pos, col_position: col_pos)
    if @pieces && @pieces.user_id == @pieces.game.white_player_id
      case @pieces.type
      when "Pawn"
        return '&#9817;'.html_safe
      when "Rook"
        return '&#9814;'.html_safe
      when "Knight"
        return '&#9816;'.html_safe
      when "Bishop"
        return '&#9815;'.html_safe
      when "Queen"
        return '&#9812;'.html_safe
      when "King"
        return '&#9813;'.html_safe
      end
    elsif @pieces && @pieces.user_id == @pieces.game.black_player_id
      case @pieces.type
      when "Pawn"
        return '&#9823;'.html_safe
      when "Rook"
        return '&#9820;'.html_safe
      when "Knight"
        return '&#9822;'.html_safe
      when "Bishop"
        return '&#9821;'.html_safe
      when "Queen"
        return '&#9818;'.html_safe
      when "King"
        return '&#9819;'.html_safe
      end
    else
      return link_to ' ', piece_path(row_position: row_pos, col_position: col_pos), method: :put, class: 'square'
    end
  end

  def selected?(piece, game_pieces, row_pos, col_pos)
    @pieces = game_pieces.find_by(row_position: row_pos, col_position: col_pos)
    return true if @pieces && @pieces.id == piece.id
  end
end
