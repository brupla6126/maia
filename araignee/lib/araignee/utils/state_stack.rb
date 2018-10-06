require 'araignee/utils/state'

# To represent a stack of states
class StateStack
  attr_reader :states

  def initialize
    @states = []
  end

  def current
    states.last
  end

  def push(state)
    current&.pause

    states.push(state)

    state.enter
  end

  def pop
    current&.leave

    states.pop

    current&.resume
  end

  def pop_until(state)
    return unless states.include?(state)

    loop do
      break if current.equal?(state)

      pop
    end
  end
end
