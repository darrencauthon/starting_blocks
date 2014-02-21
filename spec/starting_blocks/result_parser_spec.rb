require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StartingBlocks::ResultParser do

  it "should return the result from the text parser" do

    text          = Object.new
    parsed_output = Hash.new
    text_parser   = Object.new

    StartingBlocks::ResultTextParser.stubs(:new).returns text_parser
    text_parser.stubs(:parse).with(text).returns parsed_output

    output = StartingBlocks::ResultParser.new.parse text

    output.must_be_same_as parsed_output
      
  end

end
