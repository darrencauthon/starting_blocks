module StartingBlocks
  class ResultParser
    def parse(text)

      {
        tests: text.scan(/(\d+ tests)/)[-1][0].split(' ')[0].to_i,
        assertions: text.scan(/(\d+ assertions)/)[-1][0].split(' ')[0].to_i,
        failures: text.scan(/(\d+ failures)/)[-1][0].split(' ')[0].to_i,
        errors: text.scan(/(\d+ errors)/)[-1][0].split(' ')[0].to_i,
        skips: text.scan(/(\d+ skips)/)[-1][0].split(' ')[0].to_i
      }
    end
  end
end

