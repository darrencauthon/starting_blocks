module StartingBlocks
  module Publisher
    class << self
      attr_accessor :subscribers, :result_parser

      def publish_results results
        return unless @subscribers
        @subscribers.each do |s| 
          parsed_results = StartingBlocks::Publisher.result_parser.parse(results)
          s.receive_results parsed_results
        end
      end

      def publish_specs_to_run specs
        return unless @subscribers
        @subscribers.each do |s| 
          s.receive_specs_to_run specs
        end
      end
    end
  end
end
StartingBlocks::Publisher.subscribers = []
StartingBlocks::Publisher.result_parser = StartingBlocks::ResultParser.new
