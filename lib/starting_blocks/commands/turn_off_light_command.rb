module StartingBlocks
  class TurnOffLightCommand < Command

    def valid?
      options[:turn_light_off]
    end

    def execute
      StartingBlocks::Extensions::BlinkyLighting.turn_off!
    end
  end
end
