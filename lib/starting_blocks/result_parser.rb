module StartingBlocks
  class ResultParser
    def parse text
      StartingBlocks::ResultTextParser.new.parse text
    end
  end
end
