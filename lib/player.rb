class Player
  
  attr_accessor :position, :balance, :name, :won, :jail_count
  
  def initialize(game, name)
    @position = 0
    @doubles_count = 0
    @balance = 1500
    @game = game
    @dice = game.dice
    @board = game.board
    @name = name
    #@owned_properties = []
    @bankrupt_status = false
    @won = false
    @jail_count = 0
  end
  
  # View Methods
  def display_player_starting_round
    puts "#{@name} is starting round, balance is #{@balance} and properties owned is #{owned_properties.size}"
  end
  
  def display_dice_roll_value
    puts "#{@name} rolled a #{@dice.value}"
  end
  
  def display_passed_go
    puts "#{@name} passed go and collected $200!"
  end
  
  def display_landed_on_square(square)
    puts "#{@name} landed on #{square.name}."
  end
  
  def display_current_balance
    puts "#{@name}'s current balance: #{@balance}."
  end
  
  def display_purchased_property(property)
    puts "#{@name} purchased #{property.name}."
  end
  
  def display_rent_paid(property)
    puts "#{@name} paid #{property.rent} in rent to #{property.owner.name}."
  end
  
  def display_player_bankrupt
    puts "#{@name} is out of money! Wambulance called..."
  end
  
  def display_cant_afford(player)
    puts "#{player.name} can't afford this."
  end
  
  def display_cant_afford_without_selling_assets 
    puts "You can only afford this by selling assets. Do you want to sell assets? (Y/N)"
  end
  
  def display_need_to_sell_assets
    puts "You still need to raise more money to afford it.  Which asset 
    do you want to sell?"
  end
  
  def display_go_to_jail_message
    puts "You're going to jail!"
  end
  
  def display_bankrupt_warning
    puts "You have to continue selling assets until you can afford rent or you will go bankrupt."
  end
  
  def display_property_menu
    puts "Type the number of the property you would like to trade."
    owned_properties.each do |key, property|
      puts "#{key}: #{property.name}"
    end
  end
  
  def display_price_requested
    puts "Type in the price you would like for this property."
  end
  
  def display_choose_player
    puts "------------Players-------------"
    puts "Type the number of the player you would like to trade with."
    @game.players.each_with_index do |player, index|
      unless player == self
        puts "#{index}: #{player.name}"
      end
    end
  end
  
  def display_offer_message(offering, requesting, player)
    puts "#{self.name} is offering to trade with #{player.name}."
    puts "they are offering #{offering.name} for #{requesting}"
    puts "does #{player.name} accept? (Y/N)"
  end
  
  def display_offer_completed(offering, requesting, player)
    puts "#{self.name} completed trade with #{player.name}."
    puts "They traded #{offering.name} for #{requesting}."
  end
  
  def display_trading_option
    puts "Would you like to sell any properties to other players?"
  end
  
  def display_mortgage_menu
    puts "------------Mortgage Properties-------------"
    puts "Type the number of the property you would like to mortgage."
    owned_properties.each do |key, property|
      unless property.mortgaged == true
        puts "#{key}: #{property.name}"
      end
    end
  end
  
  def display_player_options_menu
    puts "------------Options Menu-------------"
    puts "Type the number of the option you want (or press enter to skip):"
    puts "1: Trade with other players."
    puts "2: Mortgage properties."
    puts "3: Sell houses and/or hotels to bank."
    puts "4: Purchase improvements" if has_monopolies?
  end
  
  def display_buy_improvements_menu
    puts "------------Sell Improvements Menu-------------"
    puts "Type the number of the property for which you would like to buy improvements."
    owned_properties.each do |key, property|
      if property.is_monopoly?
        puts "#{key}: #{property.name}, existing improvements: #{property.improvements}, 
        improvements cost: #{property.improvements_cost} each."
      end
    end    
  end
  
  def display_buy_improvements_count
    
  end
  
  def display_sell_trade_mortgage
    puts "Would you like to sell/ trade assets or mortgage properties? (Y/N)"
  end
  
  def display_final_bankrupt_warning
    puts "Are you sure? You'll be declared bankrupt unless you raise more money. (Y/N)"
  end
  
  def display_sell_improvements_menu
    puts "------------Sell Improvements Menu-------------"
    puts "Type the number of the property for which you would like to sell improvements."
    owned_properties.each do |key, property|
      if property.has_improvements?
        puts "#{key}: #{property.name}, improvements: #{property.improvements}, sale value: 
        #{property.sale_value}"
      end
    end
  end
  
  def display_sell_improvements_count(property)
    puts "There are #{property.improvements} improvements for this property."
    puts "How many do you want to sell?"
  end
  
  # Controller Methods
  def player_input_affirmative?
    gets.chomp[0].upcase == "Y"
  end
  
  def player_input_negative?
    gets.chomp[0].upcase == "N"
  end
  
  def player_input_integer
    gets.chomp.to_i
  end
  
  # Model Methods
  
  def owned_properties
    @board.squares.select {|key, square| square.is_a?(Property) && square.owner == self}
  end
  
  def owned_property_names
    names = []
    owned_properties.each do |key, property|
      names << property.name
    end
    names
  end
  
  def play_round
    puts "----------------------NEW ROUND---------------------------"
    puts "#{self.name} owns: #{owned_property_names}"
    display_player_starting_round
    roll_dice
    display_dice_roll_value
    if third_double?
      go_to_jail 
    elsif in_jail?
      play_jail_round
    else
      finish_round
    end
    cleanup_phase
  end
  
  def third_double?
    @doubles_count == 3
  end
  
  def has_monopolies?
    @board.squares.select {|key, square| square.is_a?(Property) && square.is_monopoly?}.any?
  end

  def finish_round
    advance_token
    handle_square
    player_options_menu
    play_round if play_again? && @bankrupt_status == false
  end
  
  def handle_mortgaging_phase
    display_mortgage_menu
    selected_property = owned_properties[player_input_integer]
    mortgage(selected_property)
  end
  
  def mortgage(property)
    property.mortgaged = true
    add_funds(property.price / 2)
  end
  
  def handle_trading_phase
    display_trading_option
    if player_input_affirmative?
      display_property_menu
      offering = owned_properties[player_input_integer]
      display_price_requested
      requesting = player_input_integer
      display_choose_player
      player = @game.players[player_input_integer]
      offer_trade(offering, requesting, player)
    end
  end
  
  def offer_trade(offering, requesting, player)
    display_offer_message(offering, requesting, player)
    if player_input_affirmative?
      handle_trade(offering, requesting, player)
    end
  end
  
  def handle_trade(offering, requesting, player)
    if player.can_afford?(requesting)
      offering.set_owner(player)
      player.deduct_funds(requesting)
      self.add_funds(requesting)
      display_offer_completed(offering, requesting, player)
    else
      display_cant_afford(player)
    end
  end
  
  def play_jail_round  
    if @dice.doubles
      @jail_count = 0
      finish_round
    else
      @jail_count += 1
      if @jail_count >= 3
        deduct_funds(50)
        @jail_count = 0
      end
    end 
  end
  
  def play_again?
    if @doubles_count > 0 && @doubles_count < 3
      true
    else
      false
    end
  end
  
  def cleanup_phase
    @doubles_count = 0
  end

  def roll_dice
    @dice.roll!
    @doubles_count += 1 if @dice.doubles?
  end
  
  def won?
    @won
  end
  
  def in_jail?
    @jail_count > 1
  end
  
  def go_to_jail
    display_go_to_jail_message
    @jail_count = 1
    @position = @board.position_at(:jail)
  end

  def advance_token
    advance_by(@dice.value)    
  end

  def advance_by(dice_value) 
    pending_position = @position + dice_value
    @position = @board.loop_position(pending_position, self)
  end
  
  def pass_go
    display_passed_go
    add_funds(1)
  end
  
  def handle_square
    square = @board.square_at(@position)
    display_landed_on_square(square)
    square.process(self)
  end

  def raise_money_phase(price, optional = true)
    done = false
    unless optional
      display_bankrupt_warning
    end
    until can_afford?(price) || done do
      display_sell_trade_mortgage
      if player_input_negative?
        if optional
          done = true
        else
          display_final_bankrupt_warning
          done = player_input_affirmative?
        end        
      end
      player_options_menu unless done
    end
  end
  
  def player_options_menu
    display_player_options_menu
    selection = player_input_integer
    case selection
    when 1
      handle_trading_phase
    when 2
      handle_mortgaging_phase
    when 3
      handle_sell_improvements_phase
    end
  end
  
  def handle_sell_improvements_phase
    display_sell_improvements_menu
    property = owned_properties[player_input_integer]
    display_sell_improvements_count(property)
    property.sell_improvements(self, player_input_integer)
    display_current_balance
  end
  
  def can_afford?(amount)
    @balance >= amount
  end
  
  def deduct_funds(amount)
    @balance -= amount
  end
  
  def add_funds(amount)
    @balance += amount
  end
  
  def purchase_property(property)
    deduct_funds(property.price)
    property.set_owner(self)
    #@owned_properties << property
    display_purchased_property(property)
    display_current_balance
  end
  
  def pay_rent(property)
    raise_money_phase(property.rent, false)
    if can_afford?(property.rent)
      deduct_funds(property.rent)
      property.owner.add_funds(property.rent)
      display_rent_paid(property)
      display_current_balance
    else
      bankrupt!
    end
  end
  
  def is_bankrupt?
    @bankrupt_status == true
  end
  
  def bankrupt!
    display_player_bankrupt
    @bankrupt_status = true
  end
  
end