class Game
  def initialize
    create_players
    @players.shuffle
    @current_turn_index = 0
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
    @players[@current_turn_index].play_round
  end

  def game_over?
    @players.select { | player | player.won? }.any?
  end
end