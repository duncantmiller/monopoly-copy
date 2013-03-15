class Game
  
  def initalize(*player_names) # game.new(tom dick harry)
    @board = Board.new
    @dice = Dice.new
    @players = []
    player_names.each do |name|
      @players << Player.new(name)
    end
    # need way to cap game at 6 players
  end
  
  # Needs win condition
  def play
    until winner? do
      play_round
    end
  end
  
  def play_round
    @players.each do |player|
      play_turn(player)
    end
  end

   #needs refactoring
  def play_turn(player)
    roll = roll_dice
    if third_double?
      go_to_jail(player)
    else
      move_player(player,roll)
      square = @board.return_square(player.position)
      square.play!
      if rolled_doubles?
        play_turn(player)
      end
    end
    reset_doubles_count(player)
  end
 
  def move_player(player, roll)
    pending_position = player.position + roll 
    player.position = @board.loop_around_board(pending_position)
  end
  
  def rolled_doubles?
    @dice.rolled_doubles?
  end
  
  def third_double?
    if rolled_doubles?
      player.doubles_count += 1
    end
    player.doubles_count >= 3
  end
  
  def reset_doubles_count(player)
    player.doubles_count = 0
  end

  # def go_to_jail(player)
  # end
end


#game = Game.new("todd", "marry", "sue")
#game.play

  