class GameController
  attr_accessor :player, :board
  
  
  def initialize(player)
    @board = Board.new
    @player = Player.new(player)
  end

  def take_turn(player)
    roll_dice
    @board.advance_token(player, @current_die_roll)
  end
  
  
  
  
  def roll_dice
    #naive implementation... needs improvement
    @current_die_roll = rand(5)
  end
  
  
end