require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class AppleCommand
  class << self; attr_accessor :options; end
  def initialize(options)
    AppleCommand.options = options
  end
end

class OrangeCommand
  class << self; attr_accessor :options; end
  def initialize(options)
    OrangeCommand.options = options
  end
end

class BananaCommand
  class << self; attr_accessor :options; end
  def initialize(options)
    BananaCommand.options = options
  end
end

describe StartingBlocks::Command do

  let(:options) { { test: Object.new } }

  describe "#appropriate_command_for" do
    describe "no commands" do
      it "should return nothing" do
        StartingBlocks::Command.commands = []
        command = StartingBlocks::Command.appropriate_command_for options
        command.nil?.must_equal true
      end
    end

    [AppleCommand, OrangeCommand, BananaCommand].each do |valid_command|
      describe "one valid and two invalid commands" do
        let(:commands) { [AppleCommand, OrangeCommand, BananaCommand] }

        before do
          AppleCommand.any_instance.stubs(:valid?).returns(valid_command == AppleCommand)
          OrangeCommand.any_instance.stubs(:valid?).returns(valid_command == OrangeCommand)
          BananaCommand.any_instance.stubs(:valid?).returns(valid_command == BananaCommand)
          StartingBlocks::Command.commands = commands
          @command = StartingBlocks::Command.appropriate_command_for options
        end

        it "should return the valid command" do
          @command.class.must_equal valid_command
        end

        it "should have passed the " do
          AppleCommand.options.must_equal options
          BananaCommand.options.must_equal options
          OrangeCommand.options.must_equal options
        end
      end
    end
  end

  describe "initialize" do
    it "should set the options value" do
      options = Object.new
      command = StartingBlocks::Command.new(options)
      command.options.must_be_same_as options
    end
  end
end
