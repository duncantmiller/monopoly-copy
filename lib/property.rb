class Property
  
  attr_accessor :name, :color, :owner, :mortgaged, :houses, :hotels, :price
  
  def initialize(name, price, color, rent_levels)
    @name = name
    @price = price
    @color = color
    @houses = 0
    @hotels = 0
    @rent_levels = rent_levels
  end

  def process(player)
    if for_sale?
      offer_property_for_sale(player)
    elsif owned_by?(player)
      puts "you already own this property"
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
    if (answer == 'y' && player.can_afford?(@price))
      player.purchase_property(self)
      @owner = player
    else
      auction_property
    end
  end
  
  def auction_property
  end

  def assess_rent(player)
    unless @mortgaged
      puts "you owe #{rent}"
      player.pay_rent(self)
    end
  end
  
  def rent
    @rent_levels[@houses + (@hotels * 5)]
  end 
end