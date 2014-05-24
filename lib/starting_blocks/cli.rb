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
          if operation = StartingBlocks.conditional_operations[argument]
            operation.call
          end
        end
        operations_to_always_run.each { |_, o| o.call }
      end

      def operations_to_always_run
        {
          "vendor"  => (-> { StartingBlocks.options[:no_vendor]   = (StartingBlocks.arguments.include?(:vendor) == false) }),
          "bundler" => (-> { StartingBlocks.options[:use_bundler] = (Dir['Gemfile'].count > 0) } )
        }
      end

      def run_the_appropriate_command
        StartingBlocks.actions[name_of_action_to_take].call
      end

      def name_of_action_to_take
        action = StartingBlocks.actions.keys.select { |x| StartingBlocks.arguments.include? x }.first
        action || :run_all_tests
      end

    end

  end

end
