require 'araignee/utils/log'

class State
  attr_reader :context

  def initialize(context)
    @context = context
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
