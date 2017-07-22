#!/usr/bin/env ruby
# encoding: utf-8
require 'araignee/ai/behavior/sequence'
require_relative 'actions'

include Araignee::AI::Behavior

RSpec.describe Araignee::AI::Behavior::Sequence do
  let(:world) do
    world = double('world')
    allow(world).to receive(:delta) { 1 }
    world
  end

  describe '#initialize' do
    context 'when sequence empty' do
      it 'should raise ArgumentError must have at least one child node' do
        expect { Sequence.new }.to raise_error(ArgumentError, 'must have at least one child node')
      end
    end
  end

  describe '#process' do
    context 'when ActionSuccess, ActionSuccess' do
      let(:sequence) { Sequence.new(nodes: [ActionSuccess.new, ActionSuccess.new]) }
      before { sequence.start }

      it 'succeeded? should equal true' do
        entity = { number: 0 }
        expect(sequence.process(entity, world).succeeded?).to eq(true)
      end

      it 'entity :number should equal 2' do
        entity = { number: 0 }
        sequence.process(entity, world)
        expect(entity[:number]).to eq(2)
      end
    end

    context 'when ActionSuccess, ActionRunning, ActionSuccess' do
      let(:sequence) { Sequence.new(nodes: [ActionSuccess.new, ActionRunning.new, ActionSuccess.new]) }
      before { sequence.start }

      it 'running? should equal true' do
        entity = { number: 0 }
        expect(sequence.process(entity, world).running?).to eq(true)
        expect(entity[:number]).to eq(1)
      end

      it 'entity :number should equal 1' do
        entity = { number: 0 }
        sequence.process(entity, world)
        expect(entity[:number]).to eq(1)
      end
    end

    context 'when ActionFailure, ActionSuccess' do
      let(:sequence) { Sequence.new(nodes: [ActionFailure.new, ActionSuccess.new]) }
      before { sequence.start }

      it 'failed? should equal true' do
        expect(sequence.process({}, world).failed?).to eq(true)
      end
      it 'entity :number should equal 1' do
        entity = { number: 0 }
        sequence.process(entity, world)
        expect(entity[:number]).to eq(0)
      end
    end
  end
end
