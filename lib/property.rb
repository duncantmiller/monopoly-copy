
class Property
  
  attr_accessor :name, :color, :owner, :mortgage, :houses 
  
  def initialize(name, price, color)
    @name = name
    @price = price
    @color = color   
  end

  def play!(player)
    puts "Landed on square. This is #{@name}."
    if for_sale?
      offer_property_for_sale
    elsif owned_by?(player)
      return
    else
      assess_rent(player)        
    end
  end

  def for_sale?
    !@owner
  end
  
  def owned_by?(player)
    player == @owner
  end



  def offer_property_for_sale
  end

  def assess_rent(player)
  end
  
end



