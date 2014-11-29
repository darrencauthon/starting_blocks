require_relative "starting_blocks/bash_publisher"
require_relative "starting_blocks/result_builder"
Dir[File.dirname(__FILE__) + '/starting_blocks/*.rb'].each { |f| require f }

module StartingBlocks

  class << self

    attr_accessor :verbose, :options, :arguments, :conditional_operations

    def options
      @options ||= {}
    end

    def arguments
      @arguments ||= []
    end

    def actions
      @actions ||= StartingBlocks::Default.actions
    end

    def conditional_operations
      @conditional_operations ||= StartingBlocks::Default.conditional_operations
    end

    def operations_to_always_run
      @operations_to_always_run ||= StartingBlocks::Default.operations_to_always_run
    end

  end

end
