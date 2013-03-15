class Dice
  
  def roll_dice
    dice1 = rand(6) + 1 
    dice2 = rand(6) + 1
    unless rolled_doubles?
      dice1 + dice2
    else
      increment_player_doubles_count
      dice1 + dice2
    end
  end
  
  def rolled_doubles?
    @dice1 == @dice2
  end
  
end