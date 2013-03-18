class Player
  
  attr_accessor :position
  
  def initialize(game)
    @position = 0
    @doubles_count = 0
    @dice = game.dice
    @board = game.board
  end
  
  def play_round
    roll_dice
    puts roll_dice
    advance_token
    handle_square
    handle_trading_phase
    check_win_loss
    play_round if play_again?
    cleanup_phase
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
    puts square
  end

end