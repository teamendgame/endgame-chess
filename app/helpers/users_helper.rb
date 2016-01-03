module UsersHelper
  def which_king?(game)
    return '<span class="king">&#9818;</span>'.html_safe if game.black_player_id == current_user.id
    '<span class="king">&#9812;</span>'.html_safe if game.white_player_id == current_user.id
  end

  def which_color?(game)
    return 'title="You are playing black"'.html_safe if game.black_player_id == current_user.id
    'title="You are playing white"'.html_safe if game.white_player_id == current_user.id
  end
end
