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

  #View Methods
  
  def display_purchase_option
    puts "This property is for sale for #{@price}.  Would you like to buy it now?"
  end
  
  def display_property_already_owned
    puts "you already own this property"
  end
  
  def display_rent_owed
    puts "you owe #{rent}"
  end
  
  #Controller Methods

  def player_input_affirmative?
    gets.chomp[0].upcase == "Y"
  end


  #Model Methods

  def process(player)
    if for_sale?
      offer_property_for_sale(player)
    elsif owned_by?(player)
      display_property_already_owned
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
    display_purchase_option
    if player_input_affirmative? && player.can_afford?(@price)
      player.purchase_property(self)
    else
      auction_property
    end
  end
  
  def set_owner(player)
    @owner = player
  end
  
  def auction_property
  end

  def assess_rent(player)
    unless @mortgaged
      display_rent_owed
      player.pay_rent(self)
    end
  end
  
  def rent
    @rent_levels[@houses + (@hotels * 5)]
  end 
end