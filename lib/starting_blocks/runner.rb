module StartingBlocks
  class Runner

    include Displayable

    def initialize options
      @verbose = options[:verbose]
    end

    def run_files files
      display "Files to run: #{files.inspect}"
      StartingBlocks::Publisher.publish_files_to_run files
      results = execute_these_files files
      StartingBlocks::Publisher.publish_results results
      puts results
    end

    private

    def execute_these_files files
      requires = files.map { |x| "require '#{x}'" }.join("\n")
      `ruby -e "#{requires}"`
    end
  end
end
