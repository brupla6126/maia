require 'araignee/utils/log'

# Module for gathering AI classes
module AI
  # Representing a stack of states
  class State
    @states = []

    def self.current
      @states.last
    end

    def self.push(state)
      current.pause if current

      @states.push(state)

      state.enter
    end

    def self.pop
      current && current.leave
      @states.pop
      # previous_state = @states.pop
      # previous_state.leave if previous_state

      current.resume if current
    end

    def self.pop_until(state)
      pop until current.is_a?(state) || @states.empty?
    end

    def self.count
      @states.count
    end

    def self.clear
      @states.clear
    end

    # instance methods
    def initialize(options = {})
      @options = options
    end

    # called when entering the state
    def enter
      Log[:state].info { "Entering state #{self.class}" }
    end

    # called when pausing the state
    def pause
      Log[:state].info { "Pausing state #{self.class}" }
    end

    # called when resuming the state
    def resume
      Log[:state].info { "Resuming state #{self.class}" }
    end

    # called when leaving the state
    def leave
      Log[:state].info { "Leaving state #{self.class}" }
    end
  end
end
