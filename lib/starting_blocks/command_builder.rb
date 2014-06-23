module StartingBlocks

  class RunExecuter

    def initialize options
      @options = options
    end

    def self.build_for options
      RubyRunExecuter.new(@options)
    end

  end

  class RubyRunExecuter < RunExecuter

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
