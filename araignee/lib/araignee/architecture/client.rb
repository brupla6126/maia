require 'araignee/utils/state_stack'

module Architecture
  # Class for sending requests
  # The States implement config, setup and serve behaviors.
  class Client
    attr_accessor :states

    # states instance of StateStack
    def initialize(states)
      @states = states
    end
  end
end
