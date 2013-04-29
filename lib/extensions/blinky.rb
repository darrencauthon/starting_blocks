require 'blinky'

module StartingBlocks
  module Extensions
    class GreenOnSuccessRedOnFailure

      def receive_specs_to_run specs
        @spec_count = specs.count
        return if specs.count == 0
        change_color_to :yellow
      end

      def receive_results results
        return if @spec_count == 0
        if (results[:tests] || 0) == 0
          change_color_to :red
        elsif (results[:errors] || 0) > 0
          change_color_to :red
        elsif (results[:failures] || 0) > 0
          change_color_to :red
        elsif (results[:skips] || 0) > 0
          change_color_to :yellow
        else
          change_color_to :green
        end
      end

      def change_color_to(color)
        case color
        when :green
          Blinky.new.light.success!
        when :red
          Blinky.new.light.failure!
        when :yellow
          Blinky.new.light.building!
        end
      end
    end
  end
end
