require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StartingBlocks::Publisher do

  let(:results)        { Object.new }
  let(:parsed_results) { Object.new }
  let(:result_parser)  { mock()     }
  let(:files)          { Object.new }

  before do
    result_parser.stubs(:parse).with(results).returns parsed_results
    StartingBlocks::Publisher.result_parser = result_parser
  end

  describe "#publish_results" do
    describe "one subscriber" do
      it "should pass the results to the subscriber" do
        subscriber = mock()
        subscriber.expects(:receive_results).with(parsed_results)
        StartingBlocks::Publisher.subscribers = [subscriber]
        StartingBlocks::Publisher.publish_results results
      end
    end

    describe "two subscribers" do
      it "should pass the results to the subscriber" do
        first_subscriber = mock()
        first_subscriber.expects(:receive_results).with(parsed_results)
        second_subscriber = mock()
        second_subscriber.expects(:receive_results).with(parsed_results)
        StartingBlocks::Publisher.subscribers = [first_subscriber, second_subscriber]
        StartingBlocks::Publisher.publish_results results
      end
    end

    describe "nil subscribers" do
      it "should not error" do
        StartingBlocks::Publisher.subscribers = nil
        StartingBlocks::Publisher.publish_results results
      end
    end

    describe "no subscribers" do
      it "should not error" do
        StartingBlocks::Publisher.subscribers = []
        StartingBlocks::Publisher.publish_results results
      end
    end

    describe "subscriber with no method to receive" do
      it "should pass the results to the subscriber" do
        first_subscriber = mock()
        first_subscriber.expects(:receive_results).with(parsed_results)
        second_subscriber = Object.new
        third_subscriber = mock()
        third_subscriber.expects(:receive_results).with(parsed_results)
        StartingBlocks::Publisher.subscribers = [first_subscriber, second_subscriber, third_subscriber]
        StartingBlocks::Publisher.publish_results results
      end
    end
  end

  describe "#publish_files_to_run" do
    describe "one subscriber" do
      it "should pass the files to the subscriber" do
        subscriber = mock()
        subscriber.expects(:receive_files_to_run).with(files)
        StartingBlocks::Publisher.subscribers = [subscriber]
        StartingBlocks::Publisher.publish_files_to_run files
      end
    end

    describe "two subscribers" do
      it "should pass the files to the subscriber" do
        first_subscriber = mock()
        first_subscriber.expects(:receive_files_to_run).with(files)
        second_subscriber = mock()
        second_subscriber.expects(:receive_files_to_run).with(files)
        StartingBlocks::Publisher.subscribers = [first_subscriber, second_subscriber]
        StartingBlocks::Publisher.publish_files_to_run files
      end
    end

    describe "nil subscribers" do
      it "should not error" do
        StartingBlocks::Publisher.subscribers = nil
        StartingBlocks::Publisher.publish_files_to_run files
      end
    end

    describe "no subscribers" do
      it "should not error" do
        StartingBlocks::Publisher.subscribers = []
        StartingBlocks::Publisher.publish_files_to_run files
      end
    end

    describe "subscriber with no method to receive" do
      it "should not error" do
        first_subscriber = mock()
        first_subscriber.expects(:receive_files_to_run).with(files)
        second_subscriber = Object.new
        third_subscriber = mock()
        third_subscriber.expects(:receive_files_to_run).with(files)
        StartingBlocks::Publisher.subscribers = [first_subscriber, second_subscriber, third_subscriber]
        StartingBlocks::Publisher.publish_files_to_run files
      end
    end
  end
end
