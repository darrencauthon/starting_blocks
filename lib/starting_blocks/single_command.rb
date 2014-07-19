module StartingBlocks
  class SingleCommand
    def initialize command
      @command = command
    end

    def execute
      StartingBlocks::Bash.run(@command)[:success]
    end
  end
end
