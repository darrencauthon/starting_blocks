require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StartingBlocks::OptionBuilder do

  let(:option_builder) { StartingBlocks::OptionBuilder.new }

  describe "build" do

    let(:expected_options) do
      { use_bundler:    false,
        verbose:        false,
        turn_light_off: false,
        watch:          false }
    end

    it "should return empty has for no options" do
      option_builder.build([]).must_equal(expected_options)
    end

    it "should set use_bundler to true when --bundler" do
      expected_options[:use_bundler] = true
      option_builder.build(['--bundler']).must_equal expected_options
    end

    it "should set verbose to true when --verbose" do
      expected_options[:verbose] = true
      option_builder.build(['--verbose']).must_equal expected_options
    end

    it "should set turn_light_off when --off" do
      expected_options[:turn_light_off] = true
      option_builder.build(['--off']).must_equal expected_options
    end

    it "should set watch when --watch" do
      expected_options[:watch] = true
      option_builder.build(['--watch']).must_equal expected_options
    end
  end
end
