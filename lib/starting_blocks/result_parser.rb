module StartingBlocks
  class ResultParser
    def parse(text)
      @text = text
      {
        tests:      greater_of([tests, runs]),
        assertions: assertions,
        failures:   failures,
        errors:     errors,
        skips:      skips
      }
    end

    private

    def method_missing(meth, *args, &blk)
      get_count_of meth.to_s
    end

    def get_count_of name
      @text.scan(/(\d+ #{name})/)[-1][0].split(' ')[0].to_i
    rescue
      0
    end

    def greater_of values
      values.sort_by { |x| x }.last
    end
  end
end

