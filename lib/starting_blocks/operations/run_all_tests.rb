module StartingBlocks

  class RunAllTests < Operation

    def self.id
      :run_all_tests
    end

    def run
      results = run_all_specs.call
                parsed_results = StartingBlocks::Publisher.result_builder.build_from results
      success = parsed_results[:color] == :green
      exit success
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
