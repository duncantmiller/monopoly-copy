class Board
  attr_accessor :squares
  
  def initialize
    @squares = {}
    set_squares
  end
  
  #placeholder objects for now
  def set_squares
    n = 0
    40.times do
      @squares[n] = Property.new("placeholder #{n}", 200, :blue, [20, 200, 300, 400, 500, 600])
      n += 1
    end
  end
  
  def loop_position(position, player)
    if position > 39
      player.pass_go
      position - 40
    else
      position
    end
  end 

  def return_square(position)
    @squares[position]
  end

end