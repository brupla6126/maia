#!/usr/bin/env ruby
# encoding: utf-8
require 'logger'
require 'araignee/ai/node'

include Araignee::AI

RSpec.describe Araignee::AI::Node do
  let(:world) do
    world = double('world')
    allow(world).to receive(:delta) { 1 }
    world
  end

  describe '#initialize' do
    context 'without attributes' do
      let(:node) { Node.new }

      it 'state should equal :initialized' do
        expect(node.state?(:initialized)).to eq(true)
      end
      it 'elapsed should equal 0' do
        expect(node.elapsed).to eq(0)
      end
      it 'priority should equal 0' do
        expect(node.priority).to eq(0)
      end
      it 'parent should equal nil' do
        expect(node.parent).to eq(nil)
      end
    end

    context 'priority set to -1' do
      let(:node) { Node.new(priority: -1) }

      it 'should raise ArgumentError, priority must be >= 0' do
        expect { node }.to raise_error(ArgumentError, 'priority must be >= 0')
      end
    end

    context 'weight set to -1' do
      it 'should raise ArgumentError, weight must be >= 0' do
        expect { Node.new(weight: -1) }.to raise_error(ArgumentError, 'weight must be >= 0')
      end
    end
  end

  describe '' do
    context 'with values set with accessors' do
      let(:node) { Node.new }
      before { node.start }

      it 'values should be set' do
        node.elapsed = 25
        node.priority = 25
        expect(node.elapsed).to eq(25)
        expect(node.priority).to eq(25)
      end
    end
  end

  describe '#process' do
    let(:entity) { {} }
    let(:node) { Node.new }

    context 'when entity parameter is nil' do
      it 'raises ArgumentError, entity nil' do
        expect { node.process(nil, world) }.to raise_error(ArgumentError, 'entity nil')
      end
    end

    context 'when entity parameter is nil' do
      before do
        node.failure
        node.process(entity, world)
      end

      it 'node @elapsed should be updated' do
        expect(node.elapsed).to eq(1)
      end
    end

    context 'priority set to -1' do
      let(:node) { Node.new(priority: -1) }

      it 'should raise ArgumentError, priority must be >= 0' do
        expect { node }.to raise_error(ArgumentError, 'priority must be >= 0')
      end
    end

    context 'weight set to -1' do
      it 'should raise ArgumentError, weight must be >= 0' do
        expect { Node.new(weight: -1) }.to raise_error(ArgumentError, 'weight must be >= 0')
      end
    end
  end

  describe '#start' do
    let(:node) { Node.new }
    before do
      node.fire_state_event(:start)
    end

    context 'from state :initiated' do
      it 'running? should equal true' do
        expect(node.running?).to eq(true)
        expect(node.succeeded?).to eq(false)
        expect(node.failed?).to eq(false)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(false)
        expect(node.terminated?).to eq(false)
      end
    end

    context 'from state :running' do
      before do
        node.fire_state_event(:start)
      end
      it 'running? should stay equal true' do
        expect(node.running?).to eq(true)
        expect(node.succeeded?).to eq(false)
        expect(node.failed?).to eq(false)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(false)
        expect(node.terminated?).to eq(false)
      end
    end

    context 'from state :canceled' do
      before do
        node.fire_state_event(:cancel)
        node.fire_state_event(:start)
      end

      it 'running? should equal true' do
        expect(node.running?).to eq(true)
        expect(node.succeeded?).to eq(false)
        expect(node.failed?).to eq(false)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(false)
        expect(node.terminated?).to eq(false)
      end
    end

    context 'from state :paused' do
      before do
        node.fire_state_event(:pause)
        node.fire_state_event(:start)
      end

      it 'paused? should equal true' do
        expect(node.running?).to eq(false)
        expect(node.succeeded?).to eq(false)
        expect(node.failed?).to eq(false)
        expect(node.paused?).to eq(true)
        expect(node.canceled?).to eq(false)
        expect(node.terminated?).to eq(false)
      end
    end

    context 'from state :succeeded' do
      before do
        node.fire_state_event(:success)
        node.fire_state_event(:start)
      end

      it 'running? should equal true' do
        expect(node.running?).to eq(true)
        expect(node.succeeded?).to eq(false)
        expect(node.failed?).to eq(false)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(false)
        expect(node.terminated?).to eq(false)
      end
    end

    context 'from state :failed' do
      before do
        node.fire_state_event(:failure)
        node.fire_state_event(:start)
      end

      it 'running? should equal true' do
        expect(node.running?).to eq(true)
        expect(node.succeeded?).to eq(false)
        expect(node.failed?).to eq(false)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(false)
        expect(node.terminated?).to eq(false)
      end
    end

    context 'from state :terminated' do
      before do
        node.fire_state_event(:terminate)
        node.fire_state_event(:start)
      end

      it 'terminated? should equal true' do
        expect(node.running?).to eq(false)
        expect(node.succeeded?).to eq(false)
        expect(node.failed?).to eq(false)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(false)
        expect(node.terminated?).to eq(true)
      end
    end
  end

  describe '#success' do
    let(:node) { Node.new }
    before do
      node.fire_state_event(:start)
    end

    context 'from state :running' do
      before do
        node.fire_state_event(:success)
      end
      it 'running? should equal true' do
        expect(node.running?).to eq(false)
        expect(node.succeeded?).to eq(true)
        expect(node.failed?).to eq(false)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(false)
        expect(node.terminated?).to eq(false)
      end
    end

    context 'from state :canceled' do
      before do
        node.fire_state_event(:cancel)
        node.fire_state_event(:success)
      end

      it 'canceled? should stay equal true' do
        expect(node.running?).to eq(false)
        # expect(node.processing?).to eq(true)
        expect(node.succeeded?).to eq(false)
        expect(node.failed?).to eq(false)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(true)
        expect(node.terminated?).to eq(false)
      end
    end

    context 'from state :paused' do
      before do
        node.fire_state_event(:pause)
        node.fire_state_event(:success)
      end

      it 'paused? should stay equal true' do
        expect(node.running?).to eq(false)
        expect(node.succeeded?).to eq(false)
        expect(node.failed?).to eq(false)
        expect(node.paused?).to eq(true)
        expect(node.canceled?).to eq(false)
        expect(node.terminated?).to eq(false)
      end
    end

    context 'from state :succeeded' do
      before do
        node.fire_state_event(:success)
        node.fire_state_event(:success)
      end

      it 'running? should equal true' do
        expect(node.running?).to eq(false)
        expect(node.succeeded?).to eq(true)
        expect(node.failed?).to eq(false)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(false)
        expect(node.terminated?).to eq(false)
      end
    end

    context 'from state :failed' do
      before do
        node.fire_state_event(:failure)
        node.fire_state_event(:success)
      end

      it 'failed? should stay equal true' do
        expect(node.running?).to eq(false)
        expect(node.succeeded?).to eq(false)
        expect(node.failed?).to eq(true)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(false)
        expect(node.terminated?).to eq(false)
      end
    end

    context 'from state :terminated' do
      before do
        node.fire_state_event(:terminate)
        node.fire_state_event(:success)
      end

      it 'terminated? should stay equal true' do
        expect(node.running?).to eq(false)
        expect(node.succeeded?).to eq(false)
        expect(node.failed?).to eq(false)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(false)
        expect(node.terminated?).to eq(true)
      end
    end
  end

  describe '#failure' do
    let(:node) { Node.new }
    before do
      node.fire_state_event(:start)
    end

    context 'from state :running' do
      before do
        node.fire_state_event(:failure)
      end
      it 'running? should equal true' do
        expect(node.running?).to eq(false)
        expect(node.succeeded?).to eq(false)
        expect(node.failed?).to eq(true)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(false)
        expect(node.terminated?).to eq(false)
      end
    end

    context 'from state :canceled' do
      before do
        node.fire_state_event(:cancel)
        node.fire_state_event(:failure)
      end

      it 'canceled? should stay equal true' do
        expect(node.running?).to eq(false)
        expect(node.succeeded?).to eq(false)
        expect(node.failed?).to eq(false)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(true)
        expect(node.terminated?).to eq(false)
      end
    end

    context 'from state :paused' do
      before do
        node.fire_state_event(:pause)
        node.fire_state_event(:failure)
      end

      it 'paused? should stay equal true' do
        expect(node.running?).to eq(false)
        expect(node.succeeded?).to eq(false)
        expect(node.failed?).to eq(false)
        expect(node.paused?).to eq(true)
        expect(node.canceled?).to eq(false)
        expect(node.terminated?).to eq(false)
      end
    end

    context 'from state :succeeded' do
      before do
        node.fire_state_event(:success)
        node.fire_state_event(:failure)
      end

      it 'running? should equal true' do
        expect(node.running?).to eq(false)
        expect(node.succeeded?).to eq(true)
        expect(node.failed?).to eq(false)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(false)
        expect(node.terminated?).to eq(false)
      end
    end

    context 'from state :failed' do
      before do
        node.fire_state_event(:failure)
        node.fire_state_event(:failure)
      end

      it 'failed? should stay equal true' do
        expect(node.running?).to eq(false)
        expect(node.succeeded?).to eq(false)
        expect(node.failed?).to eq(true)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(false)
        expect(node.terminated?).to eq(false)
      end
    end

    context 'from state :terminated' do
      before do
        node.fire_state_event(:terminate)
        node.fire_state_event(:failure)
      end

      it 'terminated? should stay equal true' do
        expect(node.running?).to eq(false)
        expect(node.succeeded?).to eq(false)
        expect(node.failed?).to eq(false)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(false)
        expect(node.terminated?).to eq(true)
      end
    end
  end

  describe '#cancel' do
    let(:node) { Node.new }
    before do
      node.fire_state_event(:start)
    end

    context 'from state :running' do
      before do
        node.fire_state_event(:cancel)
      end

      it 'running? should equal true' do
        expect(node.running?).to eq(false)
        expect(node.running?).to eq(false)
        expect(node.succeeded?).to eq(false)
        expect(node.failed?).to eq(false)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(true)
        expect(node.terminated?).to eq(false)
      end
    end
  end

  describe '#pause' do
    let(:node) { Node.new }
    before do
      node.fire_state_event(:start)
    end

    context 'from state :running' do
      before do
        node.fire_state_event(:pause)
      end
      it 'running? should equal true' do
        expect(node.running?).to eq(false)
        expect(node.succeeded?).to eq(false)
        expect(node.failed?).to eq(false)
        expect(node.paused?).to eq(true)
        expect(node.canceled?).to eq(false)
        expect(node.terminated?).to eq(false)
      end
    end

    context 'from state :canceled' do
      before do
        node.fire_state_event(:cancel)
        node.fire_state_event(:pause)
      end

      it 'canceled? should stay equal true' do
        expect(node.running?).to eq(false)
        expect(node.succeeded?).to eq(false)
        expect(node.failed?).to eq(false)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(true)
        expect(node.terminated?).to eq(false)
      end
    end

    context 'from state :paused' do
      before do
        node.fire_state_event(:pause)
        node.fire_state_event(:pause)
      end

      it 'paused? should stay equal true' do
        expect(node.running?).to eq(false)
        expect(node.succeeded?).to eq(false)
        expect(node.failed?).to eq(false)
        expect(node.paused?).to eq(true)
        expect(node.canceled?).to eq(false)
        expect(node.terminated?).to eq(false)
      end
    end

    context 'from state :succeeded' do
      before do
        node.fire_state_event(:success)
        node.fire_state_event(:pause)
      end

      it 'succeeded? should stay equal true' do
        expect(node.running?).to eq(false)
        expect(node.succeeded?).to eq(true)
        expect(node.failed?).to eq(false)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(false)
        expect(node.terminated?).to eq(false)
      end
    end

    context 'from state :failed' do
      before do
        node.fire_state_event(:failure)
        node.fire_state_event(:pause)
      end

      it 'failed? should stay equal true' do
        expect(node.running?).to eq(false)
        expect(node.succeeded?).to eq(false)
        expect(node.failed?).to eq(true)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(false)
        expect(node.terminated?).to eq(false)
      end
    end

    context 'from state :terminated' do
      before do
        node.fire_state_event(:terminate)
        node.fire_state_event(:pause)
      end

      it 'terminated? should stay equal true' do
        expect(node.running?).to eq(false)
        expect(node.succeeded?).to eq(false)
        expect(node.failed?).to eq(false)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(false)
        expect(node.terminated?).to eq(true)
      end
    end
  end

  describe '#resume' do
    let(:node) { Node.new }
    before do
      node.fire_state_event(:start)
    end

    context 'from state :running' do
      before do
        node.fire_state_event(:resume)
      end
      it 'running? should equal true' do
        expect(node.running?).to eq(true)
        expect(node.succeeded?).to eq(false)
        expect(node.failed?).to eq(false)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(false)
        expect(node.terminated?).to eq(false)
      end
    end

    context 'from state :canceled' do
      before do
        node.fire_state_event(:cancel)
        node.fire_state_event(:resume)
      end

      it 'canceled? should stay equal true' do
        expect(node.running?).to eq(false)
        expect(node.succeeded?).to eq(false)
        expect(node.failed?).to eq(false)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(true)
        expect(node.terminated?).to eq(false)
      end
    end

    context 'from state :paused' do
      before do
        node.fire_state_event(:pause)
        node.fire_state_event(:resume)
      end

      it 'running? should equal true' do
        expect(node.running?).to eq(true)
        expect(node.succeeded?).to eq(false)
        expect(node.failed?).to eq(false)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(false)
        expect(node.terminated?).to eq(false)
      end
    end

    context 'from state :succeeded' do
      before do
        node.fire_state_event(:success)
        node.fire_state_event(:resume)
      end

      it 'succeeded? should stay equal true' do
        expect(node.running?).to eq(false)
        expect(node.succeeded?).to eq(true)
        expect(node.failed?).to eq(false)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(false)
        expect(node.terminated?).to eq(false)
      end
    end

    context 'from state :failed' do
      before do
        node.fire_state_event(:failure)
        node.fire_state_event(:resume)
      end

      it 'failed? should stay equal true' do
        expect(node.running?).to eq(false)
        expect(node.succeeded?).to eq(false)
        expect(node.failed?).to eq(true)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(false)
        expect(node.terminated?).to eq(false)
      end
    end

    context 'from state :terminated' do
      before do
        node.fire_state_event(:terminate)
        node.fire_state_event(:resume)
      end

      it 'terminated? should stay equal true' do
        expect(node.running?).to eq(false)
        expect(node.succeeded?).to eq(false)
        expect(node.failed?).to eq(false)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(false)
        expect(node.terminated?).to eq(true)
      end
    end

    context 'from state :canceled' do
      before do
        node.fire_state_event(:cancel)
        node.fire_state_event(:cancel)
      end

      it 'canceled? should stay equal true' do
        expect(node.running?).to eq(false)
        expect(node.succeeded?).to eq(false)
        expect(node.failed?).to eq(false)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(true)
        expect(node.terminated?).to eq(false)
      end
    end

    context 'from state :paused' do
      before do
        node.fire_state_event(:pause)
        node.fire_state_event(:cancel)
      end

      it 'paused? should stay equal true' do
        expect(node.running?).to eq(false)
        expect(node.succeeded?).to eq(false)
        expect(node.failed?).to eq(false)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(true)
        expect(node.terminated?).to eq(false)
      end
    end

    context 'from state :succeeded' do
      before do
        node.fire_state_event(:success)
        node.fire_state_event(:cancel)
      end

      it 'running? should equal true' do
        expect(node.running?).to eq(false)
        expect(node.succeeded?).to eq(true)
        expect(node.failed?).to eq(false)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(false)
        expect(node.terminated?).to eq(false)
      end
    end

    context 'from state :failed' do
      before do
        node.fire_state_event(:failure)
        node.fire_state_event(:cancel)
      end

      it 'failed? should stay equal true' do
        expect(node.running?).to eq(false)
        expect(node.succeeded?).to eq(false)
        expect(node.failed?).to eq(true)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(false)
        expect(node.terminated?).to eq(false)
      end
    end

    context 'from state :terminated' do
      before do
        node.fire_state_event(:terminate)
        node.fire_state_event(:cancel)
      end

      it 'terminated? should stay equal true' do
        expect(node.running?).to eq(false)
        expect(node.succeeded?).to eq(false)
        expect(node.failed?).to eq(false)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(false)
        expect(node.terminated?).to eq(true)
      end
    end
  end

  describe '#terminate' do
    let(:node) { Node.new }
    before do
      node.fire_state_event(:start)
    end

    context 'from state :running' do
      before do
        node.fire_state_event(:terminate)
      end
      it 'terminated? should equal true' do
        expect(node.running?).to eq(false)
        expect(node.succeeded?).to eq(false)
        expect(node.failed?).to eq(false)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(false)
        expect(node.terminated?).to eq(true)
      end
    end

    context 'from state :canceled' do
      before do
        node.fire_state_event(:cancel)
        node.fire_state_event(:terminate)
      end

      it 'terminated? should equal true' do
        expect(node.running?).to eq(false)
        expect(node.succeeded?).to eq(false)
        expect(node.failed?).to eq(false)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(false)
        expect(node.terminated?).to eq(true)
      end
    end

    context 'from state :paused' do
      before do
        node.fire_state_event(:pause)
        node.fire_state_event(:terminate)
      end

      it 'terminated? should equal true' do
        expect(node.running?).to eq(false)
        expect(node.succeeded?).to eq(false)
        expect(node.failed?).to eq(false)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(false)
        expect(node.terminated?).to eq(true)
      end
    end

    context 'from state :succeeded' do
      before do
        node.fire_state_event(:success)
        node.fire_state_event(:terminate)
      end

      it 'terminated? should equal true' do
        expect(node.running?).to eq(false)
        expect(node.succeeded?).to eq(false)
        expect(node.failed?).to eq(false)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(false)
        expect(node.terminated?).to eq(true)
      end
    end

    context 'from state :failed' do
      before do
        node.fire_state_event(:failure)
        node.fire_state_event(:terminate)
      end

      it 'terminated? should equal true' do
        expect(node.running?).to eq(false)
        expect(node.succeeded?).to eq(false)
        expect(node.failed?).to eq(false)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(false)
        expect(node.terminated?).to eq(true)
      end
    end

    context 'from state :terminated' do
      before do
        node.fire_state_event(:terminate)
        node.fire_state_event(:terminate)
      end

      it 'terminated? should stay equal true' do
        expect(node.running?).to eq(false)
        expect(node.succeeded?).to eq(false)
        expect(node.failed?).to eq(false)
        expect(node.paused?).to eq(false)
        expect(node.canceled?).to eq(false)
        expect(node.terminated?).to eq(true)
      end
    end
  end

  describe '#send_event' do
    let(:node) { Node.new }

    context 'sending event :succeeded' do
      before { node.start }

      it 'succeeded? should equal true' do
        expect(node.send(:send_event, :succeeded).succeeded?).to eq(true)
      end
    end

    context 'sending event :failed' do
      before { node.start }
      it 'failed? should equal true' do
        expect(node.send(:send_event, :failed).failed?).to eq(true)
      end
    end

    context 'sending event :running' do
      before { node.start }

      it 'running? should equal true' do
        # expect(node.send(:send_event, :running).running?).to eq(true)
      end
    end

    context 'sending event :paused' do
      before { node.start }

      it 'running? should equal true' do
        # expect(node.send(:send_event, :paused).paused?).to eq(true)
      end
    end
  end

  describe '#reset_node' do
    before { node.start }

    context 'with default values' do
      let(:node) { Node.new }

      it 'elapsed should equal 0' do
        node.elapsed = 25
        node.priority = 25

        node.reset_node
        expect(node.elapsed).to eq(0)
        expect(node.priority).to eq(0)
      end
    end

    context 'with values passed in initialize' do
      let(:node) { Node.new(elapsed: 5, priority: 10) }

      it 'elapsed should equal 5' do
        node.elapsed = 25
        node.priority = 25

        node.reset_node
        expect(node.elapsed).to eq(0)
        expect(node.priority).to eq(0)
      end
    end
  end
end
