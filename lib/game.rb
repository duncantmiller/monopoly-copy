class Game
  attr_accessor :dice, :board
  
  def initialize
    @current_turn_index = 0
    @dice = Dice.new
    @board = Board.new
    create_players
    @players.shuffle!
  end
  
  # View methods
  def display_game_over
    puts "game over #{@winner.name} won!"
  end
  
  # Model methods
  def create_players
    @players = [Player.new(self, "mike"), Player.new(self, "beth")]
  end

  def play!
    until game_over? do
      start_next_players_turn
    end
    display_game_over
  end

  def start_next_players_turn
    @current_turn_index += 1
    if @current_turn_index >= @players.size
      @current_turn_index = 0
    end
    unless @players[@current_turn_index].is_bankrupt?
      @players[@current_turn_index].play_round # this makes the order of play with @players[1] 
    end                                        # first and @players[0] last
  end

  def game_over?
    check_active_players
    @players.select { | player | player.won? }.any?
  end
  
  def check_active_players
    active_players = @players.select { | player | player.is_bankrupt? == false }
    if active_players.size == 1
      @winner = active_players.first
      @winner.won = true
    end
  end
end