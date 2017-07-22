#!/usr/bin/env ruby
# encoding: utf-8
require 'araignee/ai/behavior/repeater_until_success'
require_relative 'actions'

include Araignee::AI::Behavior

RSpec.describe Araignee::AI::Behavior::RepeaterUntilSuccess do
  let(:world) do
    world = double('world')
    allow(world).to receive(:delta) { 1 }
    world
  end

  describe '#process' do
    context 'when ActionFailure executes' do
      repeater = RepeaterUntilSuccess.new(node: ActionTemporaryFailure.new(times: 3))
      repeater.fire_state_event(:start)

      it 'succeeded? should equal true' do
        entity = { number: 0 }
        expect(repeater.process(entity, world).succeeded?).to eq(true)
      end
    end
  end
end
