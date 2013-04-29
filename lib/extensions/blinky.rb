require 'blinky'

module StartingBlocks
  module Extensions
    class GreenOnSuccessRedOnFailure

      def receive_specs_to_run specs
        @spec_count = specs.count
        return if specs.count == 0
        Blinky.new.light.building!
      end

      def receive_results results
        return if @spec_count == 0
        if (results[:tests] || 0) == 0
          Blinky.new.light.failure!
        elsif (results[:errors] || 0) > 0
          Blinky.new.light.failure!
        elsif (results[:failures] || 0) > 0
          Blinky.new.light.failure!
        elsif (results[:skips] || 0) > 0
          Blinky.new.light.building!
        else
          Blinky.new.light.success!
        end
      end
    end
  end
end
