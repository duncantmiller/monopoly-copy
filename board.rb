require_relative 'property'

class Board  
  attr_accessor :squares
  
  def initialize
    @squares = {}
    set_squares
  end
  
  def set_squares
    @squares[0] = Property.new("boardwalk", "400", "blue")
    @squares[1] = Property.new("park place", "300", "blue")
    @squares[2] = Property.new("vermont avenue", "100", "light blue")
    @squares[3] = CommunityChest.new
  end
  
  def play_square(position)
    @squares[position].play
  end
end

@new_board = Board.new
puts @new_board.inspect
puts @new_board.squares[0].name
@new_board.squares[0].play