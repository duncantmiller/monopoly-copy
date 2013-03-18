class Player
  
  def play_round
    roll_dice
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

  def advance_token
    if @doubles_count == 3
      advance_to(:jail)
    else
      advance_by @dice.value
    end
  end

end