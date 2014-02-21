module StartingBlocks
  class ResultParser
    def parse text
      output = StartingBlocks::ResultTextParser.new.parse text
      output[:color] = :red
      output
    end
  end
end
