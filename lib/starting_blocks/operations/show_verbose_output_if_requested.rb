module StartingBlocks

  class ShowVerboseOutputIfRequested < Operation

    def self.id
      :verbose
    end

    def self.conditional?
      true
    end

    def run
      StartingBlocks.verbose = true
    end

  end

end
