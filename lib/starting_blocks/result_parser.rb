module StartingBlocks
  class ResultParser
    def parse(text)
      test_count = get_count_of('tests', text)
      test_count = get_count_of('runs', text) if test_count == 0
      {
        tests: test_count,
        assertions: get_count_of('assertions', text),
        failures: get_count_of('failures', text),
        errors: get_count_of('errors', text),
        skips: get_count_of('skips', text)
      }
    end

    def get_count_of name, text
      text.scan(/(\d+ #{name})/)[-1][0].split(' ')[0].to_i
    rescue
      0
    end
  end
end

