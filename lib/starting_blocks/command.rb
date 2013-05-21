module StartingBlocks
  class Command
    class << self
      attr_accessor :commands

      def appropriate_command_for options
        @commands.map { |x| x.new }.
          select { |command| command.valid? }.
          first
      end
    end
  end
end

