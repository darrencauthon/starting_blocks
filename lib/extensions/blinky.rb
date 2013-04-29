require 'blinky'

module StartingBlocks
  module Extensions
    class GreenOnSuccessRedOnFailure

      def receive_specs_to_run specs
        Blinky.new.light.building!
      end

      def receive_results results
        if (results[:errors] || 0) > 0
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
