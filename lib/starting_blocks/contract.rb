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

end
