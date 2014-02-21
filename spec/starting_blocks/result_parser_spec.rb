require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StartingBlocks::ResultParser do

  let(:parsed_output) { {} }

  let(:output) do
    text        = Object.new
    text_parser = Object.new

    StartingBlocks::ResultTextParser.stubs(:new).returns text_parser
    text_parser.stubs(:parse).with(text).returns parsed_output

    StartingBlocks::ResultParser.new.parse text
  end

  it "should return the result from the text parser" do
    output.must_be_same_as parsed_output
  end

  describe "different output scenarios" do

    it "should set the color to red if there are no tests" do
      parsed_output[:tests] = 0
      output[:color].must_equal :red
    end

  end

end
