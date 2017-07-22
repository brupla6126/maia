#!/usr/bin/env ruby
# encoding: utf-8
require 'araignee/ai/behavior/inverter'

require_relative 'actions'

include Araignee::AI::Behavior

RSpec.describe Araignee::AI::Behavior::Inverter do
  let(:world) do
    world = double('world')
    allow(world).to receive(:delta) { 1 }
    world
  end

  describe '#initialize' do
    context 'when inverted node is nil' do
      it 'should raise ArgumentError when node is nil' do
        expect { Inverter.new(node: nil) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#process' do
    context 'when inverter inverts ActionSuccess' do
      let(:inverter) { Inverter.new(node: ActionSuccess.new) }
      before { inverter.start }

      it 'failed? should equal true' do
        entity = { number: 0 }
        expect(inverter.process(entity, world).failed?).to eq(true)
      end
    end

    context 'when inverter inverts ActionFailure' do
      let(:inverter) { Inverter.new(node: ActionFailure.new) }
      before { inverter.start }

      it 'succeeded? should equal true' do
        entity = { number: 0 }
        expect(inverter.process(entity, world).succeeded?).to eq(true)
      end
    end
  end
end
