module StartingBlocks
  class WatchCommand < Command
    def valid?
      options[:watch]
    end

    def execute
      StartingBlocks::Watcher.start_watching Dir, options
    end
  end 
end

