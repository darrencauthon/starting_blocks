module StartingBlocks
  class Runner

    include Displayable

    def initialize options
      @verbose = options[:verbose]
      @use_bundler = options[:use_bundler]
      @include_vendor = options[:no_vendor] != true
    end

    def run_files files
      display "Files to run: #{files.inspect}"
      files = files.select { |x| @include_vendor || x.include?('/vendor/') == false }
      StartingBlocks::Publisher.publish_files_to_run files
      results = execute_these_files files
      StartingBlocks::Publisher.publish_results results
      puts results
      results
    end

    private

    def execute_these_files files
      requires = files.map { |x| "require '#{x}'" }.join("\n")
      if @use_bundler
        `bundle exec ruby -e "#{requires}"`
      else
        `ruby -e "#{requires}"`
      end
    end
  end
end
