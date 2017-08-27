require 'state_machines'
require 'virtus'
require 'araignee/utils/log'

module AI
  # Node Class, base class for all nodes in the behavior tree
  class Node
    include Virtus.model

    attribute :parent, Node
    attribute :elapsed, Integer, default: 0

    state_machine :state, initial: :ready do
      event :start do
        transition %i[failed ready stopped succeeded] => :started
      end

      event :stop do
        transition %i[failed paused running started succeeded] => :stopped
      end

      event :pause do
        transition %i[running started] => :paused
      end

      event :resume do
        transition %i[paused] => :started
      end

      event :busy do
        transition %i[started] => :running
      end

      event :succeed do
        transition %i[running started] => :succeeded
      end

      event :failure do
        transition %i[running started] => :failed
      end

      before_transition any - :started => :started, do: %i[reset_node node_starting]
      after_transition any - :started => :started, do: :node_started

      before_transition any - :stopped => :stopped, do: :node_stopping
      after_transition any - :stopped => :stopped, do: :node_stopped

      before_transition any - :succeeded => :succeeded, do: :node_succeeding
      after_transition any - :succeeded => :succeeded, do: :node_succeeded

      before_transition any - :failed => :failed, do: :node_failing
      after_transition any - :failed => :failed, do: :node_failed

      before_transition any - :paused => :paused, do: :node_pausing
      after_transition any - :paused => :paused, do: :node_paused

      after_transition started: :paused, do: :pause_node
      after_transition paused: :started, do: :resume_node
    end

    def initialize(attributes = {})
      super
    end

    def process(_entity, world)
      @elapsed += world.delta

      self
    end

    def active?
      !%i[paused ready stopped].include?(state_name)
    end

    protected

    def node_starting
      Log[:ai].debug { "Starting... #{inspect}" }

      validate_attributes
    end

    def node_started
      Log[:ai].debug { "Started... #{inspect}" }
    end

    def node_stopping
      Log[:ai].debug { "Stopping... #{inspect}" }
    end

    def node_stopped
      Log[:ai].debug { "Stopped... #{inspect}" }
    end

    def node_succeeding
      Log[:ai].debug { "Succeeding... #{inspect}" }
    end

    def node_succeeded
      Log[:ai].debug { "Succeeded... #{inspect}" }
    end

    def node_failing
      Log[:ai].debug { "Failing... #{inspect}" }
    end

    def node_failed
      Log[:ai].debug { "Failed... #{inspect}" }
    end

    def node_pausing
      Log[:ai].debug { "Pausing... #{inspect}" }
    end

    def node_paused
      Log[:ai].debug { "Paused... #{inspect}" }
    end

    def pause_node
      Log[:ai].debug { "Pause... #{inspect}" }
    end

    def resume_node
      Log[:ai].debug { "Resume... #{inspect}" }

      validate_attributes
    end

    def reset_node
      reset_attribute(:elapsed)
    end

    def validate_attributes; end
  end
end
