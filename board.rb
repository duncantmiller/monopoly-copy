require_relative 'property'
require_relative 'game_controller'
require_relative 'player'

class Board  
  attr_accessor :squares
  
  def initialize
    @squares = {}
    set_squares
  end
  
  # To Do: separate into property builder
  def set_squares
    @squares[0] = Property.new("boardwalk", "400", "blue", "10", "20", "30", "40", "50", "60")
    @squares[1] = Property.new("park place", "300", "blue")
    @squares[2] = Property.new("vermont avenue", "100", "light blue")
    @squares[3] = Property.new("boardwalk", "400", "blue")
    @squares[4] = Property.new("park place", "300", "blue")
    @squares[5] = Property.new("vermont avenue", "100", "light blue")
    #@squares[3] = CommunityChest.new
  end
  
 
  
  def advance_token(player, die_roll)
    player.position += die_roll
    @squares[player.position].play!
  end
  
  
end

@game = GameController.new("Beth")
player = Player.new("Beth")
@game.take_turn(player)
# 
# @new_board = Board.new
# puts @new_board.inspect
# puts @new_board.squares[0].name
# @new_board.squares[0].play