module StartingBlocks
  module Cli
    def self.run provided_arguments

      arguments = build_all_arguments_with provided_arguments

      setup_options = {
                        blinky:      -> { require "starting_blocks-blinky" },
                        growl:       -> { require "starting_blocks-growl" },
                        stopplicht:  -> { require "starting_blocks-stopplicht" },
                        verbose:     -> { StartingBlocks.verbose }
                      }
      arguments.each do |x|
        setup_options[x].call if setup_options[x]
      end

      options = {
                  no_vendor:   (arguments.include?(:vendor) == false),
                  use_bundler: (Dir['Gemfile'].count > 0)
                }


      run_all_specs = ->(options) do
                           files = ['**/*_spec.rb*', '**/*_test.rb*', '**/test_*.rb*'].map do |d|
                             Dir[d].
                               select { |f| File.file?(f) }.
                               map    { |x| File.expand_path(x) }
                           end.flatten

                           StartingBlocks::Runner.new(options).run_files files
                         end

      actions = {
                  watch: -> do
                              listener = StartingBlocks::Watcher.start_watching Dir, options
                              StartingBlocks.display "Going to sleep, waiting for changes"

                              puts 'Enter "stop" to stop the listener'
                              puts 'Enter a blank line to run all of the tests'

                              listener.start
                              loop do
                                user_input = STDIN.gets
                                if user_input == "stop\n"
                                  exit
                                elsif user_input == "\n"
                                  run_all_specs.call options
                                end
                              end
                            end,
                  run_all_tests: -> do
                                      results = run_all_specs.call(options)

                                      parsed_results = StartingBlocks::Publisher.result_parser.parse(results)
                                      success = parsed_results[:color] == :green

                                      exit success
                                    end,
                  off: -> do
                            StartingBlocks::Extensions::BlinkyLighting.turn_off!
                          end
                }

      name_of_action_to_take = [:watch, :off].select { |x| arguments.include? x }.first || :run_all_tests

      actions[name_of_action_to_take].call
    end

    def self.build_all_arguments_with arguments
      args = [arguments, default_arguments].flatten
      args.map { |x| x.gsub('--', '').to_sym }
    end

    def self.default_arguments
      config_file = File.expand_path('~/.sb')
      return [] unless File.exists?(config_file)
      File.read(config_file).split(' ')
    end
  end
end
