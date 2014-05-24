require "starting_blocks/version"
require_relative 'starting_blocks/runner'
require_relative 'starting_blocks/watcher'
require_relative 'starting_blocks/result_parser'
require_relative 'starting_blocks/result_text_parser'
require_relative 'starting_blocks/publisher'
require_relative 'starting_blocks/cli'

module StartingBlocks

  class << self
    attr_accessor :verbose
    attr_accessor :options
    attr_accessor :arguments

    def options
      @options ||= {}
    end

    def arguments
      @arguments ||= []
    end

    def actions
      @actions ||= default_actions
    end

    private

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
           files = ['**/*_spec.rb*', '**/*_test.rb*', '**/test_*.rb*'].map do |d|
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
