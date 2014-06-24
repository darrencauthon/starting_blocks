require "starting_blocks/version"
require_relative 'starting_blocks/runner'
require_relative 'starting_blocks/watcher'
require_relative 'starting_blocks/result_parser'
require_relative 'starting_blocks/result_text_parser'
require_relative 'starting_blocks/publisher'
require_relative 'starting_blocks/cli'
require_relative 'starting_blocks/minitest_contract'

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
        verbose:     -> { StartingBlocks.verbose }
      }
    end

    def default_actions
      {
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
                                      parsed_results = StartingBlocks::Publisher.result_parser.parse(results)
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
           file_specs = contract.file_clues.map do |clue|
                          contract.extensions.map do |extension|
                            "**/*#{clue}*.#{extension.gsub('.', '')}"
                          end
                        end.flatten
           files = file_specs.map do |d|
             Dir[d].
               select { |f| File.file?(f) }.
               map    { |x| File.expand_path(x) }
           end.flatten
           StartingBlocks::Runner.new(StartingBlocks.options).run_files files
         end
    end

  end

  def self.display message
    puts message if @verbose
  end
end
#StartingBlocks::Publisher.subscribers << StartingBlocks::Extensions::BlinkyLighting.new
