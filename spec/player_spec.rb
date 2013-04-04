require 'spec_helper'

# Need a lot of help with what tests to write and how to write them

describe Player do
  before(:each) do
    @game = Game.new
    @player = Player.new(@game, "todd")
    #@dice = Dice.new
   # @dice.doubles? = true
  end  
  
  it "shouldn't have any properties" do
    @player.owned_properties.count.should == 0
  end
  
  it "should go to jail after rolling three doubles" do
    pending
    @player.roll_dice
    @player.roll_dice
    @player.roll_dice
    @player.doubles_count.should == 3
    @player.in_jail?.should == true
  end
  
  it "should collect $200 after passing Go" do
    pending
  end
  
  it "is_bankrupt? should be true if bankrupt_status is true" do
    @player.bankrupt!
    @player.is_bankrupt?.should == true
  end
    
  
  
  
end