require 'araignee/utils/state_stack'

module Araignee
  module Architecture
    # Class for handling requests
    # The States implement config, setup and serve behaviors.
    class Server
      attr_accessor :states

      # states instance of StateStack
      def initialize(states)
        @states = states
      end
    end
  end
end
