module StartingBlocks
  module Verbose
    def self.say message
      puts message if StartingBlocks.verbose
    end
  end
end
