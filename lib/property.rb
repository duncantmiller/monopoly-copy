
class Property
  
  attr_accessor :name, :color, :owner, :mortgaged, :improvements
  
  def initialize(name, price, color, rent_levels)
    @name = name
    @price = price
    @color = color
    @improvements = 0
    @rent_levels = rent_levels
  end

  def process(player)
    puts "Landed on square. This is #{@name}."
    if for_sale?
      offer_property_for_sale(player)
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

  def offer_property_for_sale(player)
    puts "#{@name} is for sale for #{@price}"
    puts "Would you like to buy it (y/n)?"
    answer = gets.chomp
    if (answer == 'y' && player.has_funds?(@price))
      player.purchase_property(@price)
      @owner = player
    else
      auction_property
    end
  end
  
  def auction_property
  end

  def assess_rent(player)
    unless @mortgaged?
      determine_rent
      player.pay_rent(@owner)
    end
  end
  
  def determine_rent
    @rent_levels[@improvements]
  end
  
end



