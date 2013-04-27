module StartingBlocks
  class Runner
    def initialize options
      @verbose = options[:verbose]
    end

    def run_files specs
      requires = specs.map { |x| "require '#{x}'" }.join("\n")
      display "Specs to run: #{specs.inspect}"
      puts `ruby -e "#{requires}"`
    end

    private

    def display message
      puts message if @verbose
    end
  end
end
