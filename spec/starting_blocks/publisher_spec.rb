require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StartingBlocks do

  it "subscribers should be empty" do
    StartingBlocks::Publisher.subscribers.count.must_equal 0
  end

  describe "one subscriber" do
    it "should pass the results to the subscriber" do
      results = Object.new
      subscriber = mock()
      subscriber.expects(:receive).with(results)
      StartingBlocks::Publisher.subscribers = [subscriber]
      StartingBlocks::Publisher.publish results
    end
  end

  describe "two subscribers" do
    it "should pass the results to the subscriber" do
      results = Object.new
      first_subscriber = mock()
      first_subscriber.expects(:receive).with(results)
      second_subscriber = mock()
      second_subscriber.expects(:receive).with(results)
      StartingBlocks::Publisher.subscribers = [first_subscriber, second_subscriber]
      StartingBlocks::Publisher.publish results
    end
  end

  describe "nil subscribers" do
    it "should not error" do
      results = Object.new
      StartingBlocks::Publisher.subscribers = nil
      StartingBlocks::Publisher.publish results
    end
  end

  describe "no subscribers" do
    it "should not error" do
      results = Object.new
      StartingBlocks::Publisher.subscribers = []
      StartingBlocks::Publisher.publish results
    end
  end

  describe "result_parser" do
    it "should default to an instance of ResultParser" do
      StartingBlocks::Publisher.result_parser.class.must_equal StartingBlocks::ResultParser
    end
  end
end
