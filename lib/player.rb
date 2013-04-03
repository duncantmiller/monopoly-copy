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
    puts "you can only afford this by selling assets. do you want to sell assets?"
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
    puts "type the number of the property you would like to trade"
    owned_properties.each do |key, property|
      puts "#{key}: #{property.name}"
    end
  end
  
  def display_price_requested
    puts "type in the price you would like for this property"
  end
  
  def display_choose_player
    puts "type the number of the player you would like to trade with"
    @game.players.each_with_index do |player, index|
      puts "#{index}: #{player.name}"
    end
  end
  
  def display_offer_message(offering, requesting, player)
    puts "#{self.name} is offering to trade with #{player.name}."
    puts "they are offering #{offering.name} for #{requesting}"
    puts "does #{player.name} accept? (Y/N)"
  end
  
  def display_offer_completed(offering, requesting, player)
    puts "#{self.name} completed trade with   #{player.name}."
    puts "they traded #{offering.name} for #{requesting}."
  end
  
  def display_trading_option
    puts "Would you like to sell any properties to other players?"
  end
  
  def display_mortgage_menu
    puts "type the number of the property you would like to mortgage"
    owned_properties.each do |key, property|
      unless property.mortgaged == true
        puts "#{key}: #{property.name}"
      end
    end
  end
  
  def display_raise_money_options
    puts "type the number of the option you would like to do:"
    puts "1: Trade with other players."
    puts "2: Mortgage properties."
    puts "3: Sell houses and/or hotels to bank."
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
  
  # def owned_property
  #   property_names = []
  #  @board.squares.select {|key, square| square.is_a?(Property) && square.owner == self}
  #   owned_properties.each do |property|
  #     property_names << property[1].name
  #   end
  #   property_names
  # end
  
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
  
  def finish_round
    advance_token
    handle_square
    #handle_trading_phase
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
  
  ### MARK METHODS 
  
  def buy_property(property)
    # code to handle transfer of ownership
  end

  def raise_money_phase(price, optional = true)
    done = false
    unless optional
      display_bankrupt_warning
    end
    until can_afford?(price) || done do
      puts "Would you like to sell/ trade assets or mortgage properties?"
      if player_input_negative?
        if optional
          done = true
        else
          puts "Are you sure? You'll be declared bankrupt unless you raise more money."
          done = player_input_affirmative?
        end        
      end
      handle_raise_money_phase unless done
    end
  end
  
  def handle_raise_money_phase
    display_raise_money_options
    selection = player_input_integer
    case selection
    when 1
      handle_trading_phase
    when 2
      handle_mortgaging_phase
    when 3
      handle_sell_improvements_phase #not done yet
    end
  end

  # def bankrupt
  #   sell_assets_phase(0)
  #   if player.balance <= 0
  #     # game over, man, game over!
  #   end
  # end
  
  ### END MARK METHODS
  
  def can_afford?(amount)
    @balance >= amount
  end
  
  # def offer_to_sell_assets(amount)
  #   display_cant_afford_without_selling_assets
  #   if player_input_affirmative?
  #     handle_asset_sale(amount)
  #   else
  #     false
  #   end
  # end
  # 
  # def handle_asset_sale(amount)
  #   assets = []
  #   until @balance >= amount
  #     display_need_to_sell_assets
  #     sell_asset
  #   end
  #   @balance >= amount
  # end
  
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
      #display_bankrupt_warning
      #pay_rent(property)
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