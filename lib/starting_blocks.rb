require "starting_blocks/version"
require_relative 'starting_blocks/runner'
require_relative 'starting_blocks/watcher'
require_relative 'starting_blocks/result_parser'
require_relative 'starting_blocks/result_text_parser'
require_relative 'starting_blocks/publisher'
require_relative 'starting_blocks/cli'
#require_relative 'extensions/blinky'

module StartingBlocks

  class << self
    attr_accessor :verbose
    attr_accessor :options
    attr_accessor :arguments

    def options
      @options ||= {}
    end

    def arguments
      @arguments ||= []
    end
  end

  def self.display message
    puts message if @verbose
  end
end
#StartingBlocks::Publisher.subscribers << StartingBlocks::Extensions::BlinkyLighting.new
