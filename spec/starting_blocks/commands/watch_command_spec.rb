require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe StartingBlocks::WatchCommand do
  it "should inherit from command" do
    StartingBlocks::WatchCommand.new(Object.new).is_a? StartingBlocks::Command
  end

  describe "execute" do
    it "should start a watcher against options and Dir" do
      options = Object.new
      watch_command = StartingBlocks::WatchCommand.new(options)
      StartingBlocks::Watcher.expects(:start_watching).with(Dir, options)
      watch_command.execute
    end
  end
end

