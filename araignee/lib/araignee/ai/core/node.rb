require 'ostruct'
require 'securerandom'
require 'state_machines'
require 'araignee/utils/emitter'

module Ai
  module Core
    # Node Class, base class for all nodes in a tree
    class Node < OpenStruct
      include Araignee::Utils::Emitter

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

      def initialize(state = {})
        super(default_attributes.merge(state))

        self.identifier ||= SecureRandom.hex
      end

      def can_start?
        %i[ready stopped].include?(state_name)
      end

      def can_stop?
        %i[paused running].include?(state_name)
      end

      def process(entity, world)
        execute(entity, world)

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

      # TODO: does not work!
      def reset_node
        reset_attribute(:state)
        reset_attribute(:response)
      end

      def validate_attributes
        raise ArgumentError, 'invalid identifier' unless identifier.instance_of?(String)
      end

      protected

      def default_attributes
        { response: :unknown }
      end

      def reset_attribute(attribute)
        self[attribute] = default_attributes[attribute]
      end

      def node_starting
        emit(:ai_node_starting, self)

        validate_attributes

        nil
      end

      def node_started
        emit(:ai_node_started, self)
      end

      def node_restarting
        emit(:ai_node_restarting, self)

        reset_node

        validate_attributes

        nil
      end

      def node_restarted
        emit(:ai_node_restarting, self)
      end

      def node_stopping
        emit(:ai_node_stopping, self)
      end

      def node_stopped
        emit(:ai_node_stopped, self)
      end

      def node_pausing
        emit(:ai_node_pausing, self)
      end

      def node_paused
        emit(:ai_node_paused, self)
      end

      def node_resuming
        emit(:ai_node_resuming, self)
      end

      def node_resumed
        emit(:ai_node_resumed, self)
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
