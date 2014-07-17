module StartingBlocks
  class PassThroughResultParser
    def parse results
      results
    end
  end

  class ResultParser

    def parse text
      output = load_the_output_from text
      output[:color] = color
      output
    end

    private

    def color
      return :red unless tests_exist?
      return :red if problems_exist?
      return :yellow if skips_exist?
      :green
    end

    def load_the_output_from text
      @output = StartingBlocks::ResultTextParser.new.parse text
    end

    def tests_exist?
      (@output[:tests] || 0) > 0
    end

    def problems_exist?
      ((@output[:errors] || 0) > 0) or ((@output[:failures] || 0) > 0)
    end

    def skips_exist?
      (@output[:skips] || 0) > 0
    end
  end
end
