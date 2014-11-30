module StartingBlocks

  module Default

    def self.operations_to_always_run
      StartingBlocks::Operation.all
        .select { |x| x.always_run }
        .map    { |x| (-> { x.new.run } ) }
    end

    def self.conditional_operations
      {
        verbose: -> { StartingBlocks.verbose = true },
      }
    end

    def self.actions
      {
        run_all_tests: -> do
                            results = run_all_specs.call
                                      parsed_results = StartingBlocks::Publisher.result_builder.build_from results
                            success = parsed_results[:color] == :green
                                      exit success
                          end,
      }.merge(StartingBlocks::Operation.all.reject { |x| x.always_run }.reduce({}) { |t, i| t.merge!(i.id => (-> { i.new.run })) })
    end

    def self.run_all_specs
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
