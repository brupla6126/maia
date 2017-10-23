require 'hooks'
require 'securerandom'
require 'state_machines'
require 'virtus'
require 'araignee/utils/log'
require 'araignee/utils/recorder'

module Ai
  module Core
    # Node Class, base class for all nodes in the behavior tree
    class Node
      include Hooks
      include Virtus.model

      attribute :identifier, String, default: ->(_node, _attribute) { SecureRandom.hex }
      attribute :response, Symbol, default: :unknown
      attribute :recorder, Recorder, default: nil
      attribute :start_time, Time, default: nil, writer: :private
      attribute :stop_time, Time, default: nil, writer: :private

      state_machine :state, initial: :ready do
        event :start do
          transition %i[ready stopped] => :running
        end

        event :stop do
          transition %i[paused running] => :stopped
        end

        event :pause do
          transition %i[running] => :paused
        end

        event :resume do
          transition %i[paused] => :running
        end

        before_transition %i[ready resume start] => :running, do: :node_starting
        after_transition %i[ready resume start] => :running, do: :node_started
        before_transition %i[stopped] => :running, do: :node_restarting
        after_transition %i[stopped] => :running, do: :node_restarted
        before_transition %i[paused running] => :stopped, do: :node_stopping
        after_transition %i[paused running] => :stopped, do: :node_stopped
        before_transition %i[running] => :paused, do: :node_pausing
        after_transition %i[running] => :paused, do: :node_paused
        before_transition %i[paused] => :running, do: :node_resuming
        after_transition %i[paused] => :running, do: :node_resumed
      end

      define_hook :before_execute, :after_execute

      before_execute :start_recording
      after_execute :stop_recording

      def initialize(attributes = {})
        raise ArgumentError, 'attributes must be Hash' unless attributes.instance_of?(Hash)

        super(attributes)
      end

      def can_stop?
        %i[paused running].include?(state_name)
      end

      def process(entity, world)
        run_hook :before_execute
        execute(entity, world)
        run_hook :after_execute

        self
      end

      def busy?
        response.equal?(:busy)
      end

      def failed?
        response.equal?(:failed)
      end

      def succeeded?
        response.equal?(:succeeded)
      end

      def reset_node
        reset_attribute(:response)
      end

      def validate_attributes
        raise ArgumentError, 'invalid identifier' unless identifier.instance_of?(String)
      end

      protected

      def start_recording
        return unless recorder

        @start_time = Time.now

        nil
      end

      def stop_recording
        return unless recorder

        @stop_time = Time.now
        duration = (stop_time - start_time).round(4)

        recorder.record(:duration, duration)
        # recorder.record(response, 1)

        nil
      end

      def node_starting
        Log[:ai].debug { "Starting: #{inspect}" }

        validate_attributes

        nil
      end

      def node_started
        Log[:ai].debug { "Started: #{inspect}" }
      end

      def node_restarting
        Log[:ai].debug { "Restarting: #{inspect}" }

        reset_node

        validate_attributes

        nil
      end

      def node_restarted
        Log[:ai].debug { "Restarted: #{inspect}" }
      end

      def node_stopping
        Log[:ai].debug { "Stopping: #{inspect}" }
      end

      def node_stopped
        Log[:ai].debug { "Stopped: #{inspect}" }
      end

      def node_pausing
        Log[:ai].debug { "Pausing: #{inspect}" }
      end

      def node_paused
        Log[:ai].debug { "Paused: #{inspect}" }
      end

      def node_resuming
        Log[:ai].debug { "Resuming: #{inspect}" }
      end

      def node_resumed
        Log[:ai].debug { "Resumed: #{inspect}" }
      end

      def update_response(response)
        raise ArgumentError, "invalid response: #{response}" unless %i[busy failed succeeded].include?(response)

        self.response = response
      end

      # Implement this method in derived classes to do the node's behavior.
      def execute(_entity, _world) end
    end
  end
end
