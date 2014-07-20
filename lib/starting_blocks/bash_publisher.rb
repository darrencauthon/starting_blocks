module StartingBlocks

  class BashPublisher

    def receive_results results
      puts results[:text]
    end

  end

end
