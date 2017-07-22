#!/usr/bin/env ruby
# encoding: utf-8

require 'observer'
require 'state_machines'
require 'virtus'
require 'araignee/utils/log'

include Araignee::Utils

# Module Araignee
module Araignee
  # Module for gathering AI classes
  module AI
    # Node Class, base class for all nodes in the behavior tree
    class Node
      include Observable
      include Virtus.model

      attribute :parent, Node
      attribute :elapsed, Integer, default: 0
      attribute :priority, Integer, default: 0 # ascending
      attribute :weight, Integer, default: 0 # ascending

      state_machine :state, initial: :initialized do
        before_transition initialized: any - :initialized, do: :reset_node

        # after_transition on: :start, do: :tow
        event :start do
          transition [:initialized, :canceled, :failed, :succeeded] => :running
        end

        after_transition initialized: :running, do: :start_node
        after_transition succeeded: :running, do: :start_node

        # after_transition all: :succeeded, do: :success_node
        after_transition running: :succeeded, do: :success_node
        after_transition running: :failed, do: :failure_node
        after_transition running: :paused, do: :pause_node
        after_transition paused: :running, do: :resume_node
        after_transition any => :canceled, do: :cancel_node
        after_transition any => :terminated, do: :terminate_node

        event :success do
          transition [:running] => :succeeded
        end

        event :failure do
          transition [:running] => :failed
        end

        event :cancel do
          transition [:running, :paused] => :canceled
        end

        event :pause do
          transition [:running] => :paused
        end

        event :resume do
          transition [:paused] => :running
        end

        # event :terminate do
        #  transition [:running, :paused] => :terminated
        # end
        event :terminate do
          transition all => :terminated
        end

        # after_transition all do |node, transition|
        # Log[self.class].debug { "#{class}: node: #{node}" }
        # Log[self.class].debug { "#{class}: state: #{node.state_name}" }
        # end
      end

      def initialize(attributes = {})
        super

        validate_attributes

        self
      end

      def process(entity, world)
        raise ArgumentError, 'entity nil' unless entity

        validate_attributes

        @elapsed += world.delta

        self
      end

      def start_node
        Log[self.class].debug { "Starting... #{inspect}" }
      end

      def success_node
        Log[self.class].debug { "Success... #{inspect}" }
      end

      def failure_node
        Log[self.class].debug { "Failure... #{inspect}" }
      end

      def pause_node
        Log[self.class].debug { "Pause... #{inspect}" }
      end

      def resume_node
        Log[self.class].debug { "Resume... #{inspect}" }
      end

      def cancel_node
        Log[self.class].debug { "Cancelling... #{inspect}" }
      end

      def terminate_node
        Log[self.class].debug { "Terminate... #{inspect}" }
      end

      def reset_node
        reset_attribute(:elapsed)
        reset_attribute(:priority)
        reset_attribute(:weight)
      end

      protected

      def send_event(state)
        Log[self.class].debug { "state: #{state}" }

        event =
          case state
          when :succeeded then :success
          when :failed then :failure
            # when :paused then :pause
          end

        Log[self.class].debug { "event: #{event}" }

        fire_state_event(event)

        self
      end

      def validate_attributes
        raise ArgumentError, 'priority must be >= 0' unless @priority >= 0
        raise ArgumentError, 'weight must be >= 0' unless @weight >= 0
      end
    end
  end
end
