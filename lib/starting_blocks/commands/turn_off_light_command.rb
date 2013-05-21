module StartingBlocks
  class TurnOffLightCommand < Command
    def execute
      StartingBlocks::Extensions::BlinkyLighting.turn_off!
    end
  end
end
