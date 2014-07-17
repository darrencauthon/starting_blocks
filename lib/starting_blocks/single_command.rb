module StartingBlocks
  class SingleCommand
    def initialize command
      @command = command
    end

    def execute
      `#{@command}`
      $?.success?
    end
  end
end
