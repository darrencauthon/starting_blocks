require "starting_blocks/version"
require_relative 'starting_blocks/displayable'
require_relative 'starting_blocks/runner'
require_relative 'starting_blocks/watcher'
require_relative 'starting_blocks/result_parser'
require_relative 'starting_blocks/publisher'
require_relative 'extensions/blinky'

module StartingBlocks
  # Your code goes here...
end
StartingBlocks::Publisher.subscribers << StartingBlocks::Extensions::GreenOnSuccessRedOnFailure.new
