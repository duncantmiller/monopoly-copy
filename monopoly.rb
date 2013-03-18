require_relative 'lib/game'
require_relative 'lib/dice'
require_relative 'lib/player'
require_relative 'lib/property'
require_relative 'lib/board'

game = Game.new
# puts game.inspect
game.play!

# dice = Dice.new
# puts dice.inspect