require 'araignee/utils/log'

# To represent a stack of states
class State
  @states = []

  def self.current
    @states ||= []
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

    current.resume if current
  end

  def self.pop_until(state)
    pop until current == state || @states.empty?
  end

  def self.count
    @states.count
  end

  def self.clear
    @states.clear
  end

  # called when entering the state
  def enter
    Log.info { "Entering state #{inspect}" }
  end

  # called when pausing the state
  def pause
    Log.info { "Pausing state #{inspect}" }
  end

  # called when resuming the state
  def resume
    Log.info { "Resuming state #{inspect}" }
  end

  # called when leaving the state
  def leave
    Log.info { "Leaving state #{inspect}" }
  end
end
