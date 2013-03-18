class Player
  
  attr_accessor :position, :balance
  
  def initialize(game)
    @position = 0
    @doubles_count = 0
    @balance = 1500
    @dice = game.dice
    @board = game.board
  end
  
  def play_round
    roll_dice
    puts roll_dice
    advance_token
    handle_square
    handle_trading_phase #needs to be built
    check_win_loss #needs to be built
    play_round if play_again? #needs to be built
    cleanup_phase #needs to be built
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
      puts "dice value: #{@dice.value}"
      advance_by(@dice.value)
      
    end
  end

  def advance_by(dice_value)
    @position += dice_value
  end
  
  def handle_square
    square = @board.return_square(position)
    square.process(self)
  end
  
  def has_funds?(amount)
    @balance >= amount
  end
  
  def purchase_property(price)
    @balance -= price
    puts "new balance: #{@balance}"
    #may want to add property to an array of owned properties down the road
  end
  
  def pay_rent(owner, rent)
    if has_funds?(rent)
      @balance -= rent
      owner.balance += rent
    else
      bankrupt
    end
  end
  
end