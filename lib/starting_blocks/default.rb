module StartingBlocks

  module Default

    def self.operations_to_always_run
      {
        "vendor"  => (-> { StartingBlocks.options[:no_vendor]   = (StartingBlocks.arguments.include?(:vendor) == false) }),
        "bundler" => (-> { StartingBlocks.options[:use_bundler] = (Dir['Gemfile'].count > 0) } )
      }
    end

    def self.conditional_operations
      {
        verbose: -> { StartingBlocks.verbose = true },
      }
    end

  end

end
