module StartingBlocks

  class Contract

    attr_reader :options

    def initialize options
      @options = options
    end

    def self.inherited klass
      @contract_types ||= []
      @contract_types << klass
    end

    def file_clues
      ["test", "spec"]
    end

    def extensions
      []
    end

    def filter_these_files files
      files
    end

    def execute_these_files files
      raise 'You have to define how to execute these files.'
    end

    def self.for options
      @contract_types.last.new options
    end

  end

  class MinitestContract < Contract

    def file_clues
      ["_test", "test_", "_spec"]
    end

    def extensions
      ['.rb']
    end

    def filter_these_files files
      files.select { |x| options[:include_vendor] || x.include?('/vendor/') == false }
    end

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
