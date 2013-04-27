module StartingBlocks
  class Runner
    def initialize options
      @verbose = options[:verbose]
    end

    def run_files specs
      display "Specs to run: #{specs.inspect}"
      results = execute_these_specs specs
      puts results
    end

    private

    def execute_these_specs specs
      requires = specs.map { |x| "require '#{x}'" }.join("\n")
      `ruby -e "#{requires}"`
    end

    def display message
      puts message if @verbose
    end
  end
end
