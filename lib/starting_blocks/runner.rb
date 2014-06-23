module StartingBlocks
  class Runner

    def initialize options
      @options = options
      @use_bundler    = options[:use_bundler]
      @include_vendor = options[:no_vendor] != true
    end

    def run_files files
      files = files.select { |x| @include_vendor || x.include?('/vendor/') == false }
      StartingBlocks.display "Files to run: #{files.inspect}"
      StartingBlocks::Publisher.publish_files_to_run files
      results = execute_these_files files
      StartingBlocks::Publisher.publish_results results
      puts results
      results
    end

    def execute_these_files files
      executer = RunExecuter.build_for @options
      executer.execute files
    end
  end
end
