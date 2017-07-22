#!/usr/bin/env ruby
# encoding: utf-8
require 'araignee/ai/behavior/action'

include Araignee::AI::Behavior

class ActionSuccess < Action
  def process(entity, world)
    super

    entity[:number] += 1

    success

    self
  end
end

class ActionFailure < Action
  def process(entity, world)
    super

    failure

    self
  end
end

class ActionTemporaryFailure < Action
  attribute :times, Integer, default: 0

  def process(entity, world)
    super

    @called ||= 0

    Log[self.class].debug { "called: #{@called}, times: #{@times}" }
    Log[self.class].debug { "node2: #{attributes}" }

    @called < @times ? fire_state_event(:failure) : fire_state_event(:success)

    Log[self.class].debug { "node3: #{attributes}" }

    @called += 1

    self
  end
end

class ActionTemporarySuccess < Action
  attribute :times, Integer, default: 0

  def process(entity, world)
    super

    @called ||= 0

    Log[self.class].debug { "called: #{@called}, times: #{@times}" }
    Log[self.class].debug { "node2: #{attributes}" }

    @called < @times ? fire_state_event(:success) : fire_state_event(:failure)

    Log[self.class].debug { "node3: #{attributes}" }

    @called += 1

    self
  end
end

class ActionRunning < Action
  def process(entity, world)
    super

    self
  end
end

class ActionCanceled < Action
  def initialize(attributes = {})
    super

    self
  end

  def start_node
    fire_state_event(:cancel)
  end
end
