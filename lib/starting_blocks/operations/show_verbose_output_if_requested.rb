module StartingBlocks

  class ShowVerboseOutputIfRequested < Operation

    def self.id
      :verbose
    end

    def self.setup?
      true
    end

    def run
      StartingBlocks.verbose = StartingBlocks.arguments.include?(:verbose)
    end

  end

end
