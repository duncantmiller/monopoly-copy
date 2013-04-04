class Board
  attr_accessor :squares
  
  def initialize
    set_squares
  end
  
  #placeholder objects for now - will probably read in a yaml file with square details
  def set_squares
    @squares = {}
    @squares[0] = SpecialSquare.new(:go)
    @squares[1] = Property.new("Meditteranean Avenue", 200, :purple, [210, 200, 300, 400, 500, 600], 50, self)
    @squares[2] = SpecialSquare.new(:community_chest)    
    @squares[3] = Property.new("Baltic Avenue", 200, :purple, [210, 200, 300, 400, 500, 600], 50, self)
    @squares[4] = SpecialSquare.new(:tax)
    @squares[5] = SpecialSquare.new(:railroad)    
    @squares[6] = Property.new("Oriental Avenue", 200, :light_purple, [210, 200, 300, 400, 500, 600], 50, self)
    @squares[7] = SpecialSquare.new(:chance)
    @squares[8] = Property.new("Vermont Avenue", 200, :light_purple, [210, 200, 300, 400, 500, 600], 50, self)
    @squares[9] = Property.new("Connecticut Avenue", 200, :light_purple, [210, 200, 300, 400, 500, 600], 50, self)
    @squares[10] = SpecialSquare.new(:jail)
    @squares[11] = Property.new("St. Charles Place", 200, :pink, [210, 200, 300, 400, 500, 600], 50, self)
    @squares[12] = SpecialSquare.new(:utility)
    @squares[13] = Property.new("States Avenue", 200, :pink, [210, 200, 300, 400, 500, 600], 50, self)
    @squares[14] = Property.new("Virginia Avenue", 200, :pink, [210, 200, 300, 400, 500, 600], 50, self)
    @squares[15] = SpecialSquare.new(:railroad)
    @squares[16] = Property.new("St. James Place", 200, :orange, [210, 200, 300, 400, 500, 600], 50, self)
    @squares[17] = SpecialSquare.new(:community_chest)    
    @squares[18] = Property.new("Tennesse Avenue", 200, :orange, [210, 200, 300, 400, 500, 600], 50, self)
    @squares[19] = Property.new("New York Avenue", 200, :orange, [210, 200, 300, 400, 500, 600], 50, self)
    @squares[20] = SpecialSquare.new(:free_parking)    
    @squares[21] = Property.new("Kentucky Avenue", 200, :red, [210, 200, 300, 400, 500, 600], 50, self)
    @squares[22] = SpecialSquare.new(:chance)
    @squares[23] = Property.new("Indiana Avenue", 200, :red, [210, 200, 300, 400, 500, 600], 50, self)
    @squares[24] = Property.new("Illinois Avenue", 200, :red, [210, 200, 300, 400, 500, 600], 50, self)
    @squares[25] = SpecialSquare.new(:railroad)
    @squares[26] = Property.new("Atlantic Avenue", 200, :yellow, [210, 200, 300, 400, 500, 600], 50, self)
    @squares[27] = Property.new("Ventnor Avenue", 200, :yellow, [210, 200, 300, 400, 500, 600], 50, self)
    @squares[28] = SpecialSquare.new(:utility)
    @squares[29] = Property.new("Marvin Gardens", 200, :yellow, [210, 200, 300, 400, 500, 600], 50, self)
    @squares[30] = SpecialSquare.new(:go_to_jail)
    @squares[31] = Property.new("Pacific Avenue", 200, :green, [210, 200, 300, 400, 500, 600], 50, self)
    @squares[32] = Property.new("North Carolina Avenue", 200, :green, [210, 200, 300, 400, 500, 600], 50, self)
    @squares[33] = SpecialSquare.new(:community_chest)    
    @squares[34] = Property.new("Pennsylvania Avenue", 200, :green, [210, 200, 300, 400, 500, 600], 50, self)
    @squares[35] = SpecialSquare.new(:railroad)
    @squares[36] = SpecialSquare.new(:chance)
    @squares[37] = Property.new("Park Place", 200, :blue, [210, 200, 300, 400, 500, 600], 50, self)
    @squares[38] = SpecialSquare.new(:tax)
    @squares[39] = Property.new("Boardwalk", 200, :blue, [210, 200, 300, 400, 500, 600], 50, self)
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