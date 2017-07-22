#!/usr/bin/env ruby
# encoding: utf-8

require 'araignee/ai/behavior/repeater'

require_relative 'actions'

include Araignee::AI::Behavior

RSpec.describe Araignee::AI::Behavior::Repeater do
  let(:world) do
    world = double('world')
    allow(world).to receive(:delta) { 1 }
    world
  end

  describe '#initialize' do
    context 'when ActionSuccess' do
      let(:repeater) { Repeater.new(node: ActionSuccess.new) }

      it 'running? should equal true' do
        repeater.fire_state_event(:start)
        expect(repeater.running?).to eq(true)
      end
    end
  end

  describe '#start' do
    context 'when ActionFailure node' do
      repeater = Repeater.new(node: ActionFailure.new)
      repeater.fire_state_event(:start)

      it 'running? should equal true' do
        expect(repeater.running?).to eq(true)
      end
      it 'node.running? should equal true' do
        expect(repeater.node.running?).to eq(true)
      end
    end
  end
end
