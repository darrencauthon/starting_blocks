module StartingBlocks
  class WatchCommand < Command
    def execute
      StartingBlocks::Watcher.start_watching Dir, options
    end
  end 
end

