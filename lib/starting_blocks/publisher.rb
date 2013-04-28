module StartingBlocks
  module Publisher
    class << self
      attr_accessor :subscribers, :result_parser

      def publish results
        return unless @subscribers
        @subscribers.each { |s| s.receive results }
      end
    end
  end
end
StartingBlocks::Publisher.subscribers = []
StartingBlocks::Publisher.result_parser = StartingBlocks::ResultParser.new
