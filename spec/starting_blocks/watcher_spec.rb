require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StartingBlocks::Watcher do

  describe "filter files according to the contract" do

    describe "filter files according to the contract" do

      it "should filter the files" do

        extensions = ['.rb']
        files = ['apple.rb', 'orange.py']
        expected_results = ['apple.rb']

        contract = Struct.new(:extensions).new extensions
        results = StartingBlocks::Watcher.filter_files_according_to_the_contract files, contract

        results.must_equal results

      end


    end

  end

end
