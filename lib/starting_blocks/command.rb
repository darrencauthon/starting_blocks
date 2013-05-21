module StartingBlocks
  class Command

    attr_accessor :options

    def initialize options
      @options = options
    end

    class << self
      attr_accessor :commands

      def inherited(command_type)
        @command_types ||= []
        @command_types << command_type
      end

      def appropriate_command_for options
        @commands.map { |x| x.new(options) }.
          select { |command| command.valid? }.
          first
      end
    end
  end
end

