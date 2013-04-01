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
    puts "#{@name} property is for sale for #{@price}.  Would you like to buy it now?"
  end
  
  def display_property_already_owned(player)
    puts "#{player.name} already owns this property"
  end
  
  def display_rent_owed(player)
    puts "#{player.name} owes #{rent}"
  end
  
  def display_not_buying(player)
    puts "#{player.name} chose not to buy this property or can't afford it."
  end
  
  def display_auction_message
    puts "property is going to auction."
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
      display_property_already_owned(player)
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
    player.display_current_balance
    player.sell_assets_phase(price)
    if player.can_afford?(price) && wants_to_buy?
      player.purchase_property(self)
    else
      display_not_buying(player)  
      auction_property
    end
  end
  
  def wants_to_buy?
    display_purchase_option()
    player_input_affirmative?
  end
  
    
  def set_owner(player)
    @owner = player
  end
  
  def auction_property
    display_auction_message
  end

  def assess_rent(player)
    unless @mortgaged
      display_rent_owed(player)
      player.pay_rent(self)
    end
  end
  
  def rent
    @rent_levels[@houses + (@hotels * 5)]
  end 
end