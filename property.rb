class Property
  
  attr_accessor :name, :color
  
  def initialize(name, rent, color)
    @name = name
    @color = color
  end

  def play!
    puts "this works"
  end
  
  # Not yet implemented
  def calc_rent
    check_if_mortgaged
    check_if_monopoly
    check_for_buildings
  end
  
end

