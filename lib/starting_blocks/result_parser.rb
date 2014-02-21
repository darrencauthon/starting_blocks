module StartingBlocks
  class ResultParser
    def parse text
      output = StartingBlocks::ResultTextParser.new.parse text
      if output[:tests] == 0
        output[:color] = :red
      elsif (output[:errors] || 0) > 0
        output[:color] = :red
      elsif (output[:failures] || 0) > 0
        output[:color] = :red
      elsif (output[:skips] || 0) == 0
        output[:color] = :green
      else
        output[:color] = :yellow
      end
      output
    end
  end
end
