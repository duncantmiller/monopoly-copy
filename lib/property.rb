
class Property
  
  attr_accessor :name, :color, :owner, :mortgaged, :improvements
  
  def initialize(name, price, color, improvement0, improvement1, improvement2, improvement3, improvement4, improvement5)
    @name = name
    @price = price
    @color = color
    @improvements_level = 0
    @improvements = []
    @improvements << improvement0
    @improvements << improvement1
    @improvements << improvement2
    @improvements << improvement3
    @improvements << improvement4
    @improvements << improvement5
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
    @improvements[@improvements_level]
  end
  
end



