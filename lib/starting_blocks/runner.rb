module StartingBlocks
  class Runner

    def initialize options
      @contract = StartingBlocks::MinitestContract.new options
      @use_bundler = options[:use_bundler]
      @include_vendor = options[:no_vendor] != true
    end

    def run_files files
      files = @contract.filter_these_files files 
      StartingBlocks.display "Files to run: #{files.inspect}"
      StartingBlocks::Publisher.publish_files_to_run files
      results = execute_these_files files
      StartingBlocks::Publisher.publish_results results
      puts results
      results
    end

    private

    def execute_these_files files
      @contract.execute_these_files files
    end

  end

end
