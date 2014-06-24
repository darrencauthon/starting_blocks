module StartingBlocks

  class Contract

    attr_reader :options

    def initialize options
      @options = options
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
      StartingBlocks::MinitestContract.new options
    end

  end

end
