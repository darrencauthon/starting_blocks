module StartingBlocks
  class RunEverythingCommand < Command

    def valid?
      false
    end

    def execute
      runner = StartingBlocks::Runner.new(options)
      runner.run_files files_to_run
    end

    private

    def files_to_run
      ['**/*_spec.rb*', '**/*_test.rb*', '**/test_*.rb*'].map do |d|
        Dir[d].
          select { |f| File.file?(f) }.
          map    { |x| File.expand_path(x) }
      end.flatten
    end
  end
end
