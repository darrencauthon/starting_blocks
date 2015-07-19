require_relative "starting_blocks/bash_publisher"
require_relative "starting_blocks/result_builder"
Dir[File.dirname(__FILE__) + '/starting_blocks/*.rb'].each { |f| require f }
Dir[File.dirname(__FILE__) + '/starting_blocks/operations/*.rb'].each { |f| require f }

module StartingBlocks

  class << self

    attr_accessor :verbose, :options, :arguments

    def options
      @options ||= {}
    end

    def arguments
      @arguments ||= []
    end

    def actions
      @actions ||= StartingBlocks::Operation.all
                     .reject { |x| x.setup? }
                     .reduce({}) { |t, i| t.merge!(i.id => (-> { i.new.run })) }
 
    end

    def setup_operations
      @setup_operations ||= StartingBlocks::Operation.all
                              .select { |x| x.setup? }
                              .map    { |x| (-> { x.new.run } ) }
    end

  end

end
