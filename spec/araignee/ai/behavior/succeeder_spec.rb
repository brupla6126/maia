#!/usr/bin/env ruby
# encoding: utf-8
require 'araignee/ai/behavior/succeeder'
require_relative 'actions'

include Araignee::AI::Behavior

RSpec.describe Araignee::AI::Behavior::Succeeder do
  let(:world) do
    world = double('world')
    allow(world).to receive(:delta) { 1 }
    world
  end

  describe '#process' do
    context 'when ActionSuccess' do
      let(:selector) { Succeeder.new(node: ActionSuccess.new) }
      before { selector.start }

      it 'succeeded? should equal true' do
        entity = { number: 0 }
        expect(selector.process(entity, world).succeeded?).to eq(true)
      end
      it 'entity :number should equal 1' do
        entity = { number: 0 }
        selector.process(entity, world)
        expect(entity[:number]).to eq(1)
      end
    end

    context 'when ActionFailure' do
      let(:selector) { Succeeder.new(node: ActionFailure.new) }
      before { selector.start }

      it 'succeeded? should equal true' do
        entity = { number: 0 }
        expect(selector.process(entity, world).succeeded?).to eq(true)
      end

      it 'entity :number should equal 0' do
        entity = { number: 0 }
        selector.process(entity, world)
        expect(entity[:number]).to eq(0)
      end
    end
  end
end
