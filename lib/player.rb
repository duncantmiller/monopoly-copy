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
    puts "#{@name} landed on #{square.name}"
  end
  
  def display_new_balance
    puts "#{@name}'s new balance: #{@balance}"
  end
  
  def display_rent_paid(property)
    puts "#{@name} paid #{property.rent} in rent to #{property.owner.name}"
  end
  
  def display_player_bankrupt
    puts "#{@name} is out of money! Wambulance called..."
  end
  
  # Controller Methods
  
  
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
    # cleanup_phase #needs to be built
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
    display_new_balance
    property.set_owner(self)
    @owned_properties << property
  end
  
  def pay_rent(property)
    if can_afford?(property.rent)
      deduct_funds(property.rent)
      display_rent_paid(property)
      display_new_balance
      property.owner.add_funds(property.rent)
    else
      bankrupt
    end
  end
  
  def bankrupt
    display_player_bankrupt
  end
  
end