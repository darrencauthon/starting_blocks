require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StartingBlocks do
  describe "#run" do
    it "should execute the appropriate command" do
      options = {}

      command = mock()
      StartingBlocks::Command.expects(:appropriate_command_for).with(options).returns command
      command.expects(:execute)

      StartingBlocks.run options
    end
  end
end
