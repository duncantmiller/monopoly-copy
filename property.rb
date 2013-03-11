class Property
  
  attr_accessor :name, :rent, :color
  
  def initialize(name, rent, color)
    @name = name
    @rent = rent
    @color = color
  end

  def play
    #check_rent
    #check_for_mortgage
    puts "this works"
  end
  
end