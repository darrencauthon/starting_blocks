module StartingBlocks

  class UseBundlerIfAGemfileExists < Operation

    def self.id
      'bundler'
    end

    def self.always_run
      true
    end

    def run
      StartingBlocks.options[:use_bundler] = bundler_should_be_used?
    end

    def bundler_should_be_used?
      Dir['Gemfile'].count > 0
    end

  end

end

