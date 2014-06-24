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

  end

end
