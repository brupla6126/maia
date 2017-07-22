#!/usr/bin/env ruby
# encoding: utf-8

require 'araignee/ai/behavior/xor'
require_relative 'actions'

include Araignee::AI::Behavior

RSpec.describe Araignee::AI::Behavior::TermXor do
  let(:world) do
    world = double('world')
    allow(world).to receive(:delta) { 1 }
    world
  end

  describe '#initialize' do
    context 'when terms parameter is not a Array' do
      it 'raises TypeError terms must be Array' do
        expect { TermXor.new({}) }.to raise_error(ArgumentError, 'must have at least one child node')
      end
    end
  end

  describe '#truth?' do
    context 'when terms are [false, false]' do
      term_xor = TermXor.new(nodes: [ActionFailure.new, ActionFailure.new])
      before { term_xor.start }

      it 'succeeded? should equal false' do
        entity = { number: 0 }
        expect(term_xor.process(entity, world).succeeded?).to eq(false)
      end
    end
    context 'when terms are [false, true]' do
      term_xor = TermXor.new(nodes: [ActionFailure.new, ActionSuccess.new])
      before { term_xor.start }

      it 'succeeded? should equal true' do
        entity = { number: 0 }
        expect(term_xor.process(entity, world).succeeded?).to eq(true)
      end
    end
    context 'when terms are [true, false]' do
      term_xor = TermXor.new(nodes: [ActionSuccess.new, ActionFailure.new])
      before { term_xor.start }

      it 'succeeded? should equal true' do
        entity = { number: 0 }
        expect(term_xor.process(entity, world).succeeded?).to eq(true)
      end
    end
    context 'when terms are [true, true]' do
      term_xor = TermXor.new(nodes: [ActionSuccess.new, ActionSuccess.new])
      before { term_xor.start }

      it 'succeeded? should equal false' do
        entity = { number: 0 }
        expect(term_xor.process(entity, world).succeeded?).to eq(false)
      end
    end
  end
end
