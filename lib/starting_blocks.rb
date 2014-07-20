require_relative "starting_blocks/bash_publisher"
require_relative "starting_blocks/result_builder"
Dir[File.dirname(__FILE__) + '/starting_blocks/*.rb'].each { |f| require f }

module StartingBlocks

  class << self
    attr_accessor :verbose
    attr_accessor :options
    attr_accessor :arguments
    attr_accessor :conditional_operations

    def options
      @options ||= {}
    end

    def arguments
      @arguments ||= []
    end

    def actions
      @actions ||= default_actions
    end

    def conditional_operations
      @conditional_operations ||= default_conditional_operations
    end

    def operations_to_always_run
      @operations_to_always_run ||= default_operations_to_always_run
    end

    private

    def default_operations_to_always_run
      {
        "vendor"  => (-> { StartingBlocks.options[:no_vendor]   = (StartingBlocks.arguments.include?(:vendor) == false) }),
        "bundler" => (-> { StartingBlocks.options[:use_bundler] = (Dir['Gemfile'].count > 0) } )
      }
    end

    def default_conditional_operations
      {
        verbose: -> { StartingBlocks.verbose = true }
      }
    end

    def default_actions
      {
        execute: -> do
                      StartingBlocks::Publisher.result_builder = StartingBlocks::PassThroughResultParser.new

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
                    StartingBlocks.display "Going to sleep, waiting for changes"
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

  def self.display message
    puts message if @verbose
  end
end
