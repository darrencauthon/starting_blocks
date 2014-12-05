module StartingBlocks

  class Operation

    def self.all
      @operations ||= []
    end

    def self.inherited type
      @operations ||= []
      @operations << type
    end

    def self.id
      raise 'implement this'
    end

    def self.always_run
      false
    end

    def run
    end

  end

end
