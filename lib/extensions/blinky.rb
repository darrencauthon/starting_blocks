require 'blinky'

# fix issue where no light will cause lock-up
module Blinky
  class LightFactory
    class << self
      alias :original_detect_lights :detect_lights
      def detect_lights plugins, recipes
        original_detect_lights plugins, recipes
      rescue
        []
      end
    end
  end
end

module StartingBlocks
  module Extensions
    class GreenOnSuccessRedOnFailure

      def initialize
        @light = Blinky.new.light
      end

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
          @light.success!
        when :red
          @light.failure!
        when :yellow
          @light.building!
        end
      rescue
      end
    end
  end
end
