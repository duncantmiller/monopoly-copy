
class Property
  
  attr_accessor :name, :color, :owner, :mortgage, :houses 
  
  def initialize(name, price, color)
    @name = name
    @price = price
    @color = color   
  end

  def play!(player)
    puts "Landed on square. This is #{@name}."
      if @owner == nil
        offer_property_for_sale
      elsif @owner == player
        return
      else
        determine_rent        
      end
    end
  end
end

