class Board
  attr_accessor :squares
  
  def initialize
    set_squares
  end
  
  #placeholder objects for now
  def set_squares
    @squares = {}
    n = 0
    40.times do
      @squares[n] = Property.new("placeholder #{n}", 200, :blue, [20, 200, 300, 400, 500, 600])
      n += 1
    end
  end
  
  def loop_position(position, player)
    if position >= @squares.size
      player.pass_go
      position - @squares.size
    else
      position
    end
  end 

  def square_at(position)
    @squares[position]
  end

end