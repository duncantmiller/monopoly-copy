class Dice
  
  def roll!
    @die1 = rand(6) + 1 
    @die2 = rand(6) + 1
  end
  
  def value
    10
    # @die1 + @die2
  end
  
  def doubles?
    @die1 == @die2
  end
  
end