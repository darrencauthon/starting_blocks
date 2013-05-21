module StartingBlocks
  class Command
    class << self
      attr_accessor :commands

      def appropriate_command_for options
        @commands.map { |x| x.new }.each do |command|
          return command if command.valid?
        end
        nil
      end
    end
  end
end

