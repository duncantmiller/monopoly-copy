class SpecialSquare
  
  attr_accessor :name
  
  def initialize(name)
    @name = name
  end
  
  def process(player)
    case @name
    when :jail
      puts "#{player.name} is just visiting."
    when :chance
      puts "#{player.name} picked a chance card"
      #draw_chance_card #for beth to build
    when :community_chest
      puts "#{player.name} picked a community chest card"
      #draw_community_chest_card #take it away beth
    when :tax
      puts "#{player.name} paid the tax."
    when :utility
      puts "#{player.name} utilized the utility."
    when :railroad
      puts "#{player.name} rode the railroad."
    when :go_to_jail
      puts "Busted!"
      player.go_to_jail
    when :go
      puts "#{player.name} passed go and collected $200."
    when :free_parking
      puts "#{player.name} is parking for free."
    end
  end
  
end