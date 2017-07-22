#!/usr/bin/env ruby
# encoding: utf-8
require 'araignee/ai/composite'

include Araignee::AI

RSpec.describe Araignee::AI::Composite do
  describe '#initialize' do
    context 'when has no children' do
      it 'should raise ArgumentError must have at least one child node' do
        expect { Composite.new(nodes: []) }.to raise_error(ArgumentError, 'must have at least one child node')
      end
    end

    context 'when initializing with 2 nodes' do
      let!(:composing1) { Node.new }
      let!(:composing2) { Node.new }
      let(:node) { Composite.new(nodes: [composing1, composing2]) }

      it 'should have 2 nodes' do
        expect(node.nodes.size).to eq(2)
      end

      it 'first child should be :composing1' do
        expect(node.nodes[0]).to eq(composing1)
      end
      it 'first child should be :composing2' do
        expect(node.nodes[1]).to eq(composing2)
      end
    end
  end

  describe '#start' do
    let(:composing1) { Node.new }
    let(:composing2) { Node.new }

    let(:node) { Composite.new(nodes: [composing1, composing2]) }
    before { node.fire_state_event(:start) }

    it 'all nodes states should equal :running' do
      expect(composing1.running?).to eq(true)
      expect(composing2.running?).to eq(true)
    end
  end

  describe '#reset_node' do
    let(:node) { Node.new }
    let(:composite) { Composite.new(nodes: [node]) }
    before { composite.reset_node }

    it 'node initialized? should equal true' do
      expect(composite.initialized?).to eq(true)
    end
    it 'compositing node initialized? should equal true' do
      expect(node.initialized?).to eq(true)
    end
    it 'compositing node running? should equal false' do
      expect(node.running?).to eq(false)
    end
    it 'compositing node succeeded? should equal false' do
      expect(node.succeeded?).to eq(false)
    end
    it 'compositing node failed? should equal false' do
      expect(node.failed?).to eq(false)
    end
  end
end
