module StartingBlocks
  class Runner

    include Displayable

    def initialize options
      @verbose = options[:verbose]
    end

    def run_files specs
      display "Specs to run: #{specs.inspect}"
      results = execute_these_specs specs
      StartingBlocks::Publisher.publish_results results
      puts results
    end

    private

    def execute_these_specs specs
      requires = specs.map { |x| "require '#{x}'" }.join("\n")
      `ruby -e "#{requires}"`
    end
  end
end
