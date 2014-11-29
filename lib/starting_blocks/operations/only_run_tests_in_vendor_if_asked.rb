module StartingBlocks

  class OnlyRunTestsInVendorIfAsked < Operation

    def id
      'vendor'
    end

    def always_run
      true
    end

    def run
      StartingBlocks.options[:no_vendor] = do_not_use_vendor?
    end

    def do_not_use_vendor?
      StartingBlocks.arguments.include?(:vendor) == false
    end

  end

end
