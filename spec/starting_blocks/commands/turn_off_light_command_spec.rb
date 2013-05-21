require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe StartingBlocks::TurnOffLightCommand do
  it "should inherit from command" do
    StartingBlocks::TurnOffLightCommand.new(nil).is_a? StartingBlocks::Command
  end

  describe "execute" do
    it "should call the command to turn off the light" do
      StartingBlocks::Extensions::BlinkyLighting.expects(:turn_off!)
      command = StartingBlocks::TurnOffLightCommand.new nil
      command.execute
    end
  end
end

