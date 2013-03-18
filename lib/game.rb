class Game
  attr_accessor :dice, :board
  
  def initialize
    @current_turn_index = 0
    @dice = Dice.new
    @board = Board.new
    create_players
    @players.shuffle
  end
  
  def create_players
    @players = [Player.new(self, "mike"), Player.new(self, "beth")]
  end

  def play!
    until game_over? do
      start_next_players_turn
    end
  end

  def start_next_players_turn
    @current_turn_index += 1
    if @current_turn_index >= @players.size
      @current_turn_index = 0
    end
    @players[@current_turn_index].play_round # this makes the order of play with @players[1] 
                                             # first and @players[0] last
  end

  def game_over?
    @players.select { | player | player.won? }.any?
  end
end