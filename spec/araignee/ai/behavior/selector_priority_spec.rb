#!/usr/bin/env ruby
# encoding: utf-8
require 'araignee/ai/behavior/selector'
require 'araignee/ai/behavior/order/order_priority'
require_relative 'actions'

include Araignee::AI::Behavior

class Araignee::AI::Behavior::SelectorPriority < Selector
  include OrderPriority
end
class Araignee::AI::Behavior::ActionSuccess
  include OrderPriority
end

RSpec.describe Araignee::AI::Behavior::SelectorPriority do
  let(:world) do
    world = double('world')
    allow(world).to receive(:delta) { 1 }
    world
  end

  describe '#initialize' do
    context 'when has less than 2 nodes' do
      it 'should raise ArgumentError must have at least one child node' do
        expect { SelectorPriority.new(nodes: []) }.to raise_error(ArgumentError, 'must have at least one child node')
      end
    end
  end

  describe '#process' do
    context 'when ActionSuccess' do
      let(:selector) { SelectorPriority.new(nodes: [ActionSuccess.new(priority: 10), ActionSuccess.new(priority: 15)]) }
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

    context 'when ActionSuccess, ActionSuccess' do
      let(:selector) { SelectorPriority.new(nodes: [ActionSuccess.new(priority: 10), ActionSuccess.new(priority: 5)]) }
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

    context 'when ActionFailure, ActionFailure, ActionSuccess' do
      let(:selector) { SelectorPriority.new(nodes: [ActionFailure.new(priority: 10), ActionFailure.new(priority: 10), ActionSuccess.new(priority: 10)]) }
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

    context 'when ActionFailure, ActionFailure' do
      let(:selector) { SelectorPriority.new(nodes: [ActionFailure.new(priority: 10), ActionFailure.new(priority: 10)]) }
      before { selector.start }

      it 'failed? should equal true' do
        entity = { number: 0 }
        expect(selector.process(entity, world).failed?).to eq(true)
      end
      it 'entity :number should equal 0' do
        entity = { number: 0 }
        selector.process(entity, world)
        expect(entity[:number]).to eq(0)
      end
    end
  end
end
