module StartingBlocks

  class ResultBuilder

    def build_from run_result
      load_the_output_from(run_result[:text])
        .merge(color: color,
               text: run_result[:text],
               exit_code: run_result[:exit_code],
               success:   run_result[:success])
    end

    private

    def color
      return :red unless tests_exist?
      return :red if problems_exist?
      return :yellow if skips_exist?
      :green
    end

    def load_the_output_from text
      @output = StartingBlocks::TextParser.new.parse text
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
