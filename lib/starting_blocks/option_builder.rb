module StartingBlocks
  class OptionBuilder
    def build options
      { use_bundler:    options.include?('--bundler'),
        verbose:        options.include?('--verbose'),
        turn_light_off: options.include?('--off'),
        watch:          options.include?('--watch') }
    end
  end
end
