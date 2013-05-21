require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe StartingBlocks::TurnOffLightCommand do
  it "should inherit from command" do
    StartingBlocks::TurnOffLightCommand.new(nil).is_a? StartingBlocks::Command
  end

  describe "valid?" do

    it "should be true when options include turn_light_off" do
      StartingBlocks::TurnOffLightCommand.new( { turn_light_off: true } ).
        valid?.must_equal true
    end

    it "should be false when options include turn_light_off" do
      StartingBlocks::TurnOffLightCommand.new( { turn_light_off: false } ).
        valid?.must_equal false
    end

  end

  describe "execute" do
    it "should call the command to turn off the light" do
      StartingBlocks::Extensions::BlinkyLighting.expects(:turn_off!)
      command = StartingBlocks::TurnOffLightCommand.new nil
      command.execute
    end
  end
end

