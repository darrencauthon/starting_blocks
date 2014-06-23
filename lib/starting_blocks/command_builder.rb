module StartingBlocks

  class CommandExecuter

    def initialize options
      @options = options
    end

    def self.build_for options
      RubyCommandBuilder.new(@options)
    end

  end

  class RubyCommandExecuter < CommandExecuter

    def execute_these_files files
      requires = files.map { |x| "require '#{x}'" }.join("\n")
      if options[:use_bundler]
        `bundle exec ruby -e "#{requires}"`
      else
        `ruby -e "#{requires}"`
      end
    end

  end

end
