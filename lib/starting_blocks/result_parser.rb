module StartingBlocks
  class ResultParser
    def parse(text)
      {
        tests: greater_of([get_count_of('tests', text),
                           get_count_of('runs',  text)]),
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

    def greater_of values
      values.sort_by { |x| x }.last
    end
  end
end

