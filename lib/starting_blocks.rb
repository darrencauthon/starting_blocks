require "starting_blocks/version"
require_relative 'starting_blocks/displayable'
require_relative 'starting_blocks/runner'
require_relative 'starting_blocks/watcher'
require_relative 'starting_blocks/result_parser'
require_relative 'starting_blocks/publisher'
require_relative 'starting_blocks/command'
require_relative 'starting_blocks/option_builder'
require_relative 'extensions/blinky'

module StartingBlocks
  def self.run options
    Command.appropriate_command_for(options).execute
  end
end
StartingBlocks::Publisher.subscribers << StartingBlocks::Extensions::BlinkyLighting.new
