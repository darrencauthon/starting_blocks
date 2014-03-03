require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StartingBlocks::Runner do
  let(:options) { {} }
  let(:runner) { StartingBlocks::Runner.new options }

  describe "run one file, no exceptions" do
    let(:files)   { ['test.rb'] }
    let(:results) { Object.new }

    before do
      StartingBlocks.expects(:display).with('Files to run: ["test.rb"]')
      runner.expects(:execute_these_files).with(files).returns results
      StartingBlocks::Publisher.expects(:publish_files_to_run).with files
      StartingBlocks::Publisher.expects(:publish_results).with results
      runner.expects(:puts).with results

      @results = runner.run_files files
    end

    it "should display the files" do
      # expectation set above
    end

    it "should public the files to run" do
      # expectation set above
    end

    it "should public the results" do
      # expectation set above
    end

    it "should put the results" do
      # expectation set above
    end

    it "should return the reuslts" do
      @results.must_be_same_as results
    end
  end

  describe "run two files, no exceptions" do
    let(:files)   { ['test1.rb', 'test2.rb'] }
    let(:results) { Object.new }

    before do
      StartingBlocks.expects(:display).with('Files to run: ["test1.rb", "test2.rb"]')
      runner.expects(:execute_these_files).with(files).returns results
      StartingBlocks::Publisher.expects(:publish_files_to_run).with files
      StartingBlocks::Publisher.expects(:publish_results).with results
      runner.expects(:puts).with results

      @results = runner.run_files files
    end

    it "should display the files" do
      # expectation set above
    end

    it "should public the files to run" do
      # expectation set above
    end

    it "should public the results" do
      # expectation set above
    end

    it "should put the results" do
      # expectation set above
    end

    it "should return the reuslts" do
      @results.must_be_same_as results
    end
  end

  describe "run two files, one from vendor, but no vendor allowed!" do
    let(:files)   { ['test1.rb', '/vendor/something_test.rb', 'test2.rb'] }
    let(:options) { { no_vendor: true } }
    let(:results) { Object.new }

    let(:files_without_vendor) { ['test1.rb', 'test2.rb'] }

    before do
      StartingBlocks.expects(:display).with('Files to run: ["test1.rb", "test2.rb"]')
      runner.expects(:execute_these_files).with(files_without_vendor).returns results
      StartingBlocks::Publisher.expects(:publish_files_to_run).with files_without_vendor
      StartingBlocks::Publisher.expects(:publish_results).with results
      runner.expects(:puts).with results

      @results = runner.run_files files
    end

    it "should display the files" do
      # expectation set above
    end

    it "should public the files to run" do
      # expectation set above
    end

    it "should public the results" do
      # expectation set above
    end

    it "should put the results" do
      # expectation set above
    end

    it "should return the reuslts" do
      @results.must_be_same_as results
    end
  end
end
