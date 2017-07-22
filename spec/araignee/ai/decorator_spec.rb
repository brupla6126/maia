#!/usr/bin/env ruby
# encoding: utf-8
require 'araignee/ai/decorator'

include Araignee::AI

RSpec.describe Araignee::AI::Decorator do
  describe '#initialize' do
    context 'when initializing' do
      let!(:decorating) { Node.new }
      let(:decorated) { Decorator.new(node: decorating) }

      it 'node should be :decorating' do
        expect(decorated.node).to eq(decorating)
      end
    end
  end

  describe '#start' do
    let(:node) { Node.new }
    let(:decorator) { Decorator.new(node: node) }

    before { decorator.fire_state_event(:start) }

    it 'decorating node running? equal true' do
      expect(node.running?).to eq(true)
    end
  end

  describe '#reset_node' do
    let(:node) { Node.new }
    let(:decorator) { Decorator.new(node: node) }
    before { decorator.reset_node }

    it 'decorator node initialized? should equal true' do
      expect(decorator.initialized?).to eq(true)
    end
    it 'decorating node initialized? should equal true' do
      expect(node.initialized?).to eq(true)
    end
    it 'decorating node running? should equal false' do
      expect(node.running?).to eq(false)
    end
    it 'decorating node succeeded? should equal false' do
      expect(node.succeeded?).to eq(false)
    end
    it 'decorating node failed? should equal false' do
      expect(node.failed?).to eq(false)
    end
  end
end
