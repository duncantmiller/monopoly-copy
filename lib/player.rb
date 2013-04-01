class Player
  
  attr_accessor :position, :balance, :name
  
  def initialize(game, name)
    @position = 0
    @doubles_count = 0
    @balance = 1500
    @dice = game.dice
    @board = game.board
    @name = name
    @owned_properties = []
  end
  
  # View Methods
  def display_player_starting_round
    puts "#{@name} is starting round"
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
  
  def display_cant_afford_without_selling_assets 
    puts "you can only afford this by selling assets. do you want to sell assets?"
  end
  
  def display_need_to_sell_assets
    puts "You still need to raise more money to afford it.  Which asset 
    do you want to sell?"
  end
  
  # Controller Methods
  def player_input_affirmative?
    gets.chomp[0].upcase == "Y"
  end
  
  # Model Methods
  
  def play_round
    display_player_starting_round
    roll_dice
    display_dice_roll_value
    advance_token
    handle_square
    puts 
    # handle_trading_phase #needs to be built
    # check_win_loss #needs to be built
    # play_round if play_again? #needs to be built
    cleanup_phase
  end
  
  def cleanup_phase
    @doubles_count = 0
  end

  def roll_dice
    @dice.roll!
    if @dice.doubles?
      @doubles_count += 1
    end
  end
  
  def won?
    false
  end

  def advance_token
    if @doubles_count == 3
      advance_to(:jail)
    else
      advance_by(@dice.value)    
    end
  end

  def advance_by(dice_value) 
    pending_position = @position + dice_value
    @position = @board.loop_position(pending_position, self)
  end
  
  def pass_go
    display_passed_go
    add_funds(200)
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

  def sell_assets_phase(price)
    done = false
    until can_afford?(price) || done do
      puts "Would you like to sell assets?"
      done = player_input_affirmative? #negative?
      display_sell_assets_menu unless done
    end
  end

  def bankrupt
    sell_assets_phase(0)
    if player.balance <= 0
      # game over, man, game over!
    end
  end
  
  ### END MARK METHODS
  
  def can_afford?(amount)
    @balance >= amount
  end
  
  def can_afford_at_all?(amount) # Needs refactoring
    if can_afford?(amount)
      true
    elsif can_afford_by_selling_assets?(amount)
      offer_to_sell_assets(amount)
    else
      false
    end
  end
  
  def offer_to_sell_assets(amount)
    display_cant_afford_without_selling_assets
    if player_input_affirmative?
      handle_asset_sale(amount)
    else
      false
    end
  end

  def handle_asset_sale(amount)
    assets = []
    until @balance >= amount
      display_need_to_sell_assets
      sell_asset
    end
    @balance >= amount
  end
  
  def networth
    # Calculate value of all properties, improvements, cash, etc.
  end
  
  def can_afford_by_selling_assets?(amount)
    networth >= amount
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
    @owned_properties << property
    display_purchased_property(property)
    display_current_balance
  end
  
  def pay_rent(property)
    if can_afford?(property.rent)
      deduct_funds(property.rent)
      property.owner.add_funds(property.rent)
      display_rent_paid(property)
      display_current_balance
    else
      bankrupt
    end
  end
  
  def bankrupt
    display_player_bankrupt
  end
  
end