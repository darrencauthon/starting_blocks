module StartingBlocks
  module Bash
    def self.run command, block = Proc.new { |command_to_run| `#{command_to_run}` }
      StartingBlocks::Verbose.say "Running: #{command}"
      text      = block.call command
      result    = $?
      {
        text:      text,
        success:   result.success?,
        exit_code: result.to_i
      }
    end
  end
end
