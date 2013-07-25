module StartingBlocks
  module Displayable
    module ClassMethods
      def display message
        puts message if @verbose
      end
    end

    module InstanceMethods
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end
