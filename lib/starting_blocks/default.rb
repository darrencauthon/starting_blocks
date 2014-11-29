module StartingBlocks

  module Default

    def self.operations_to_always_run
      #{
        #"vendor"  => (-> { OnlyRunTestsInVendorIfAsked.new.run } ),
        #"bundler" => (-> { UseBundlerIfAGemfileExists.new.run  } )
      #}
      #.select { |x| x.always_run }
      StartingBlocks::Operation.all
        .map    { |x| (-> { x.new.run } ) }
    end

    def self.conditional_operations
      {
        verbose: -> { StartingBlocks.verbose = true },
      }
    end

    def self.actions
      {
        execute: -> do
                      StartingBlocks::Publisher.result_builder = StartingBlocks::PassThroughResultBuilder.new

                      statement_to_execute = ARGV[ARGV.index('execute') + 1]
                      StartingBlocks::Publisher.publish_files_to_run [statement_to_execute]
                      result = StartingBlocks::Bash.run(statement_to_execute)
                      StartingBlocks::Publisher.publish_results( { color: (result[:success] ? :green : :red),
                                                                   tests: 1,
                                                                   assertions: 1,
                                                                   failures: (result[:success] ? 0 : 1),
                                                                   errors: 0,
                                                                   skips: 0 })
                      puts result[:text]
                    end,
        watch: -> do
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
                  end,
        run_all_tests: -> do
                            results = run_all_specs.call
                                      parsed_results = StartingBlocks::Publisher.result_builder.build_from results
                            success = parsed_results[:color] == :green
                                      exit success
                          end,
        off: -> do
                  StartingBlocks::Extensions::BlinkyLighting.turn_off!
                end
      }
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
