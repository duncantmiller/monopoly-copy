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
      @squares[n] = Property.new("placeholder #{n}", 200, :blue)
      n += 1
    end
  end

  def return_square(position)
    if position > 39
      @squares[position - 40]
    else
      @squares[position]
    end
  end

end