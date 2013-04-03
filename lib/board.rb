class Board
  attr_accessor :squares
  
  def initialize
    set_squares
  end
  
  #placeholder objects for now - will probably read in a yaml file with square details
  def set_squares
    @squares = {}
    n = 1
    2.times do
      @squares[n] = Property.new("blue placeholder #{n}", 200, :blue, [210, 200, 300, 400, 500, 600], 50, self)
      n += 1
    end
    37.times do
      @squares[n] = Property.new("red placeholder #{n}", 200, :red, [210, 200, 300, 400, 500, 600], 50, self)
      n += 1
    end
    @squares[10] = SpecialSquare.new(:jail)
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

  def position_at(name)
    square = @squares.select {|key, square| square.name == name }
    square.keys.first
  end
end