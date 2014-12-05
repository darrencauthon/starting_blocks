module StartingBlocks

  class ShowVerboseOutputIfRequested < Operation

    def self.id
      :verbose
    end

    def self.always_run
      true
    end

    def run
      StartingBlocks.verbose = StartingBlocks.arguments.include?(:verbose)
    end

  end

end
