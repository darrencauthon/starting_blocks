require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe StartingBlocks::WatchCommand do
  it "should inherit from command" do
    StartingBlocks::WatchCommand.new(Object.new).is_a? StartingBlocks::Command
  end
end

