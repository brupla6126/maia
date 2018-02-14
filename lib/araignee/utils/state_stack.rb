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
    current.pause if current

    states.push(state)

    state.enter
  end

  def pop
    current && current.leave

    states.pop

    current.resume if current
  end

  def pop_until(state)
    return unless states.include?(state)

    loop do
      pop
      break if [nil, state].include?(current)
    end
  end

  def count
    states.count
  end

  def clear
    states.clear
  end
end
