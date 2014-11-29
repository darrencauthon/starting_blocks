require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "verbose" do

  describe "say" do

    describe "and verbose mode is on" do

      before { StartingBlocks.stubs(:verbose).returns true }

      it "should puts the message" do
        input = Object.new
        StartingBlocks::Verbose.expects(:puts).with input
        StartingBlocks::Verbose.say input
      end

    end

    describe "and verbose mode is off" do

      before { StartingBlocks.stubs(:verbose).returns false }

      it "should puts the message" do
        input = Object.new
        StartingBlocks::Verbose.expects(:puts).never
        StartingBlocks::Verbose.say input
      end

    end

  end

end
