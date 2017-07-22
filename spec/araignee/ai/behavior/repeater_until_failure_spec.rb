#!/usr/bin/env ruby
# encoding: utf-8

require 'araignee/ai/behavior/repeater_until_failure'
require_relative 'actions'

include Araignee::AI::Behavior

RSpec.describe Araignee::AI::Behavior::RepeaterUntilFailure do
  let(:world) do
    world = double('world')
    allow(world).to receive(:delta) { 1 }
    world
  end

  describe '#process' do
    context 'when processing child node' do
      repeater = RepeaterUntilFailure.new(node: ActionTemporarySuccess.new(times: 3))
      repeater.fire_state_event(:start)

      it 'succeeded? should equal true' do
        entity = { number: 0 }
        expect(repeater.process(entity, world).succeeded?).to eq(true)
      end
    end
  end
end
