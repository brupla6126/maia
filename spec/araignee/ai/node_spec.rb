require 'araignee/ai/node'

RSpec.describe AI::Node do
  let(:world) { double('[world]') }

  before do
    allow(world).to receive(:delta) { 1 }
  end

  let(:node) { AI::Node.new }

  describe '#initialize' do
    context 'without attributes' do
      it 'state should be initialized' do
        expect(node.state?(:initialized)).to eq(true)
      end

      it 'elapsed should equal 0' do
        expect(node.elapsed).to eq(0)
      end

      it 'parent should equal nil' do
        expect(node.parent).to eq(nil)
      end
    end
  end

  describe '' do
    context 'with values set with accessors' do
      before { node.fire_state_event(:start) }

      it 'values should be set' do
        node.elapsed = 25

        expect(node.elapsed).to eq(25)
      end
    end
  end

  describe '#process' do
    let(:entity) { {} }

    context 'when entity parameter is nil' do
      before do
        node.failure
        node.process(entity, world)
      end

      it 'node @elapsed should be updated' do
        expect(node.elapsed).to eq(1)
      end
    end

    it 'returns self' do
      expect(node.process(entity, world)).to eq(node)
    end
  end

  describe '#start' do
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
    before { node.fire_state_event(:start) }

    context 'sending event :succeeded' do
      it 'node should have succeeded' do
        expect(node.send(:send_event, :succeeded).succeeded?).to eq(true)
      end
    end

    context 'sending event :failed' do
      it 'node should have failed' do
        expect(node.send(:send_event, :failed).failed?).to eq(true)
      end
    end

    context 'sending event :running' do
      it 'node should be running' do
        # expect(node.send(:send_event, :running).running?).to eq(true)
      end
    end

    context 'sending event :paused' do
      it 'node should be paused' do
        # expect(node.send(:send_event, :paused).paused?).to eq(true)
      end
    end
  end
end
