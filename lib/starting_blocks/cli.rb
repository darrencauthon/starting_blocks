module StartingBlocks

  module Cli

    def self.run arguments
      load_the_arguments_to_be_considered arguments
      setup_the_system
      run_the_appropriate_command
    end

    class << self

      private 

      def load_the_arguments_to_be_considered arguments
        StartingBlocks.arguments = build_all_arguments_with arguments
      end

      def build_all_arguments_with arguments
        args = [arguments, arguments_from_the_config_file].flatten
        args.map { |x| x.gsub('--', '').to_sym }
      end

      def arguments_from_the_config_file
        config_file = File.expand_path('~/.sb')
        return [] unless File.exists?(config_file)
        File.read(config_file).split(' ')
      end

      def setup_the_system
        StartingBlocks.arguments.each do |argument|
          conditional_operations[argument].call if conditional_operations[argument]
        end
        operations_to_always_run.each { |_, o| o.call }
      end

      def conditional_operations
        {
          blinky:      -> { require "starting_blocks-blinky" },
          growl:       -> { require "starting_blocks-growl" },
          stopplicht:  -> { require "starting_blocks-stopplicht" },
          verbose:     -> { StartingBlocks.verbose }
        }
      end

      def operations_to_always_run
        {
          "vendor"  => (-> { StartingBlocks.options[:no_vendor]   = (StartingBlocks.arguments.include?(:vendor) == false) }),
          "bundler" => (-> { StartingBlocks.options[:use_bundler] = (Dir['Gemfile'].count > 0) } )
        }
      end

      def run_the_appropriate_command
        actions[name_of_action_to_take].call
      end

      def name_of_action_to_take
        action = actions.keys.select { |x| StartingBlocks.arguments.include? x }.first
        action || :run_all_tests
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

      def actions
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

    end

  end

end
