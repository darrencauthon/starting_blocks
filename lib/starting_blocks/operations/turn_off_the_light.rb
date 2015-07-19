module StartingBlocks

  class TurnOffTheLight < Operation

    def self.id
      :off
    end

    def run
      StartingBlocks::Extensions::BlinkyLighting.turn_off!
    rescue
    end

  end

end
