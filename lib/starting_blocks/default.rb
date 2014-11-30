module StartingBlocks

  module Default

    def self.operations_to_always_run
      StartingBlocks::Operation.all
        .select { |x| x.always_run }
        .map    { |x| (-> { x.new.run } ) }
    end

    def self.conditional_operations
      {
        verbose: -> { StartingBlocks.verbose = true },
      }
    end

    def self.actions
      StartingBlocks::Operation.all.reject { |x| x.always_run }.reduce({}) { |t, i| t.merge!(i.id => (-> { i.new.run })) }
    end

  end

end
