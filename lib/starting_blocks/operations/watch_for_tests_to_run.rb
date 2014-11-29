module StartingBlocks

  class WatchForTestsToRun < Operation

    def self.id
      :watch
    end

    def run
      listener = StartingBlocks::Watcher.start_watching Dir, StartingBlocks.options
      StartingBlocks::Verbose.say "Going to sleep, waiting for changes"
      puts 'Enter "stop" to stop the listener'
      puts 'Enter a blank line to run all of the tests'
      listener.start
      loop do
        user_input = STDIN.gets
        if user_input == "stop\n"
          exit
        elsif user_input == "\n"
          run_all_specs.call
        end
      end
    end

    def run_all_specs
      ->() do
           contract = StartingBlocks::Contract.for StartingBlocks.options
           files = Dir['**/*'].select { |f| File.file? f }
                              .map    { |x| File.expand_path x }.flatten
           files = StartingBlocks::Watcher.filter_files_by_file_clues files, contract.file_clues
           files = StartingBlocks::Watcher.filter_files_according_to_the_contract files, contract
           StartingBlocks::Runner.new(StartingBlocks.options).run_files files
         end
    end

  end

end
