require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe StartingBlocks::WatchCommand do
  it "should inherit from command" do
    StartingBlocks::WatchCommand.new(Object.new).is_a? StartingBlocks::Command
  end

  describe "valid?" do
    it "should be valid when watch option set" do
      StartingBlocks::WatchCommand.new( { watch: true } ).valid?.must_equal true
    end

    it "should not be valid when watch option not set" do
      StartingBlocks::WatchCommand.new( { watch: false } ).valid?.must_equal false
    end
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

