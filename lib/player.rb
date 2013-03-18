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
  
  def play_round
    puts "#{@name} is starting round"
    roll_dice
    puts "#{@name} rolled a #{@dice.value}"
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
    @balance += 200
  end
  
  def handle_square
    square = @board.return_square(@position)
    puts "landed on #{square.name}"
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
    puts "new balance: #{@balance}"
    @owned_properties << property
  end
  
  def pay_rent(property)
    if can_afford?(property.rent)
      deduct_funds(property.rent)
      puts "After paying rent your balance is: #{@balance}"
      property.owner.add_funds(property.rent)
      puts "#{property.owner.name} receives #{property.rent}"
    else
      puts "your out of money"
      bankrupt
    end
  end
  
end