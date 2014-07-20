module StartingBlocks
  module Publisher
    class << self
      attr_accessor :subscribers, :result_builder

      def subscribers
        @subscribers ||= []
      end

      def result_builder
        @result_builder ||= StartingBlocks::ResultBuilder.new
      end

      def publish_results results
        return unless @subscribers
        @subscribers.each do |s| 
          parsed_results = StartingBlocks::Publisher.result_builder.build_from results
          begin
            s.receive_results parsed_results
          rescue
          end
        end
      end

      def publish_files_to_run files
        return unless @subscribers
        @subscribers.each do |s| 
          begin
            s.receive_files_to_run files
          rescue
          end
        end
      end
    end
  end
end
