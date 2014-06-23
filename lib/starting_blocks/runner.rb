module StartingBlocks
  class Runner

    def initialize options
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
