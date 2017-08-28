require 'araignee/ai/node'

RSpec.describe AI::Node do
  let(:world) { double('[world]') }

  before { allow(world).to receive(:delta) { 1 } }

  let(:node) { AI::Node.new }
  subject { node }

  describe '#initialize' do
    context 'without attributes' do
      it 'identifier should not be nil' do
        expect(node.identifier).not_to eq(nil)
      end

      it 'state should be ready' do
        expect(node.ready?).to eq(true)
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
      it 'values should be set' do
        node.elapsed = 25

        expect(node.elapsed).to eq(25)
      end
    end
  end

  describe '#process' do
    let(:entity) { {} }

    context 'when entity parameter is nil' do
      before { subject.start! }
      before { subject.process(entity, world) }

      it 'node @elapsed should be updated' do
        expect(node.elapsed).to eq(1)
      end
    end

    it 'returns self' do
      expect(node.process(entity, world)).to eq(node)
    end
  end

  describe '#active?' do
    context 'with state :ready' do
      it 'should be true' do
        expect(subject.active?).to eq(false)
      end
    end

    context 'started' do
      before { subject.start! }

      context 'with state :started' do
        it 'should be true' do
          expect(subject.active?).to eq(true)
        end
      end

      context 'with state :stopped' do
        before { subject.stop! }

        it 'should be true' do
          expect(subject.active?).to eq(false)
        end
      end

      context 'with state :paused' do
        before { subject.pause! }

        it 'should be true' do
          expect(subject.active?).to eq(false)
        end
      end

      context 'with state :running' do
        before { subject.busy! }

        it 'should be true' do
          expect(subject.active?).to eq(true)
        end
      end

      context 'with state :succeeded' do
        before { subject.succeed! }

        it 'should be true' do
          expect(subject.active?).to eq(true)
        end
      end

      context 'with state :failed' do
        before { subject.failure! }

        it 'should be true' do
          expect(subject.active?).to eq(true)
        end
      end
    end
  end

  describe '#start!' do
    context 'from state :ready' do
      before { subject.start! }

      it 'should be started' do
        expect(subject.started?).to eq(true)
      end
    end

    context 'started' do
      before { subject.start! }

      context 'from state :started' do
        it 'should raise StateMachines::InvalidTransition' do
          expect { subject.start! }.to raise_error(StateMachines::InvalidTransition)
        end
      end

      context 'from state :stopped' do
        before { subject.stop! }
        before { subject.start! }

        it 'should be started' do
          expect(subject.started?).to eq(true)
        end
      end

      context 'from state :running' do
        before { subject.busy! }

        it 'should raise StateMachines::InvalidTransition' do
          expect { subject.start! }.to raise_error(StateMachines::InvalidTransition)
        end
      end

      context 'from state :succeeded' do
        before { subject.succeed! }
        before { subject.start! }

        it 'should be started' do
          expect(subject.started?).to eq(true)
        end
      end

      context 'from state :failed' do
        before { subject.failure! }
        before { subject.start! }

        it 'should be started' do
          expect(subject.started?).to eq(true)
        end
      end
    end
  end

  describe '#stop!' do
    context 'from state :ready' do
      it 'should raise StateMachines::InvalidTransition' do
        expect { subject.stop! }.to raise_error(StateMachines::InvalidTransition)
      end
    end

    context 'started' do
      before { subject.start! }

      context 'from state :started' do
        before { subject.stop! }

        it 'should be stopped' do
          expect(node.stopped?).to eq(true)
        end
      end

      context 'from state :stopped' do
        before { subject.stop! }

        it 'should raise StateMachines::InvalidTransition' do
          expect { subject.stop! }.to raise_error(StateMachines::InvalidTransition)
        end
      end

      context 'from state :paused' do
        before { subject.pause! }
        before { subject.stop! }

        it 'should be stopped' do
          expect(node.stopped?).to eq(true)
        end
      end

      context 'from state :running' do
        before { subject.busy! }
        before { subject.stop! }

        it 'should be stopped' do
          expect(node.stopped?).to eq(true)
        end
      end

      context 'from state :succeeded' do
        before { subject.succeed! }
        before { subject.stop! }

        it 'should be stopped' do
          expect(node.stopped?).to eq(true)
        end
      end

      context 'from state :failed' do
        before { subject.failure! }
        before { subject.stop! }

        it 'should be stopped' do
          expect(node.stopped?).to eq(true)
        end
      end
    end
  end

  describe '#pause!' do
    context 'from state :ready' do
      it 'should raise StateMachines::InvalidTransition' do
        expect { subject.pause! }.to raise_error(StateMachines::InvalidTransition)
      end
    end

    context 'started' do
      before { subject.start! }

      context 'from state :started' do
        before { subject.pause! }

        it 'should be paused' do
          expect(node.paused?).to eq(true)
        end
      end

      context 'from state :stopped' do
        before { subject.stop! }

        it 'should raise StateMachines::InvalidTransition' do
          expect { subject.pause! }.to raise_error(StateMachines::InvalidTransition)
        end
      end

      context 'from state :paused' do
        before { subject.pause! }

        it 'should be paused' do
          expect(node.paused?).to eq(true)
        end
      end

      context 'from state :running' do
        before { subject.busy! }
        before { subject.pause! }

        it 'should be paused' do
          expect(node.paused?).to eq(true)
        end
      end

      context 'from state :succeeded' do
        before { subject.succeed! }

        it 'should raise StateMachines::InvalidTransition' do
          expect { subject.pause! }.to raise_error(StateMachines::InvalidTransition)
        end
      end

      context 'from state :failed' do
        before { subject.failure! }

        it 'should raise StateMachines::InvalidTransition' do
          expect { subject.pause! }.to raise_error(StateMachines::InvalidTransition)
        end
      end
    end
  end

  describe '#resume!' do
    context 'from state :ready' do
      it 'should raise StateMachines::InvalidTransition' do
        expect { subject.resume! }.to raise_error(StateMachines::InvalidTransition)
      end
    end

    context 'started' do
      before { subject.start! }

      context 'from state :started' do
        it 'should raise StateMachines::InvalidTransition' do
          expect { subject.resume! }.to raise_error(StateMachines::InvalidTransition)
        end
      end

      context 'from state :stopped' do
        before { subject.stop! }

        it 'should raise StateMachines::InvalidTransition' do
          expect { subject.resume! }.to raise_error(StateMachines::InvalidTransition)
        end
      end

      context 'from state :paused' do
        before { subject.pause! }
        before { subject.resume! }

        it 'should be started' do
          expect(node.started?).to eq(true)
        end
      end

      context 'from state :running' do
        before { subject.busy! }

        it 'should raise StateMachines::InvalidTransition' do
          expect { subject.resume! }.to raise_error(StateMachines::InvalidTransition)
        end
      end

      context 'from state :succeeded' do
        before { subject.succeed! }

        it 'should raise StateMachines::InvalidTransition' do
          expect { subject.resume! }.to raise_error(StateMachines::InvalidTransition)
        end
      end

      context 'from state :failed' do
        before { subject.failure! }

        it 'should raise StateMachines::InvalidTransition' do
          expect { subject.resume! }.to raise_error(StateMachines::InvalidTransition)
        end
      end
    end
  end

  describe '#busy!' do
    context 'from state :ready' do
      it 'should raise StateMachines::InvalidTransition' do
        expect { subject.busy! }.to raise_error(StateMachines::InvalidTransition)
      end
    end

    context 'started' do
      before { subject.start! }

      context 'from state :started' do
        before { subject.busy! }

        it 'should be running' do
          expect(node.running?).to eq(true)
        end
      end

      context 'from state :stopped' do
        before { subject.stop! }

        it 'should raise StateMachines::InvalidTransition' do
          expect { subject.busy! }.to raise_error(StateMachines::InvalidTransition)
        end
      end

      context 'from state :paused' do
        before { subject.pause! }

        it 'should raise StateMachines::InvalidTransition' do
          expect { subject.busy! }.to raise_error(StateMachines::InvalidTransition)
        end
      end

      context 'from state :running' do
        before { subject.busy! }

        it 'should raise StateMachines::InvalidTransition' do
          expect { subject.busy! }.to raise_error(StateMachines::InvalidTransition)
        end
      end

      context 'from state :succeeded' do
        before { subject.succeed! }

        it 'should raise StateMachines::InvalidTransition' do
          expect { subject.busy! }.to raise_error(StateMachines::InvalidTransition)
        end
      end

      context 'from state :failed' do
        before { subject.failure! }

        it 'should raise StateMachines::InvalidTransition' do
          expect { subject.busy! }.to raise_error(StateMachines::InvalidTransition)
        end
      end
    end
  end

  describe '#succeed!' do
    context 'from state :ready' do
      it 'should raise StateMachines::InvalidTransition' do
        expect { subject.succeed! }.to raise_error(StateMachines::InvalidTransition)
      end
    end

    context 'started' do
      before { subject.start! }

      context 'from state :started' do
        before { subject.succeed! }

        it 'should be succeeded' do
          expect(node.succeeded?).to eq(true)
        end
      end

      context 'from state :stopped' do
        before { subject.stop! }

        it 'should raise StateMachines::InvalidTransition' do
          expect { subject.succeed! }.to raise_error(StateMachines::InvalidTransition)
        end
      end

      context 'from state :paused' do
        before { subject.pause! }

        it 'should raise StateMachines::InvalidTransition' do
          expect { subject.succeed! }.to raise_error(StateMachines::InvalidTransition)
        end
      end

      context 'from state :running' do
        before { subject.busy! }
        before { subject.succeed! }

        it 'should be succeeded' do
          expect(node.succeeded?).to eq(true)
        end
      end

      context 'from state :succeeded' do
        before { subject.succeed! }

        it 'should raise StateMachines::InvalidTransition' do
          expect { subject.succeed! }.to raise_error(StateMachines::InvalidTransition)
        end
      end

      context 'from state :failed' do
        before { subject.failure! }

        it 'should raise StateMachines::InvalidTransition' do
          expect { subject.succeed! }.to raise_error(StateMachines::InvalidTransition)
        end
      end
    end
  end

  describe '#failure!' do
    context 'from state :ready' do
      it 'should raise StateMachines::InvalidTransition' do
        expect { subject.failure! }.to raise_error(StateMachines::InvalidTransition)
      end
    end

    context 'started' do
      before { subject.start! }

      context 'from state :started' do
        before { subject.failure! }

        it 'should be failed' do
          expect(node.failed?).to eq(true)
        end
      end

      context 'from state :stopped' do
        before { subject.stop! }

        it 'should raise StateMachines::InvalidTransition' do
          expect { subject.failure! }.to raise_error(StateMachines::InvalidTransition)
        end
      end

      context 'from state :paused' do
        before { subject.pause! }

        it 'should raise StateMachines::InvalidTransition' do
          expect { subject.failure! }.to raise_error(StateMachines::InvalidTransition)
        end
      end

      context 'from state :running' do
        before { subject.busy! }
        before { subject.failure! }

        it 'should be failed' do
          expect(node.failed?).to eq(true)
        end
      end

      context 'from state :succeeded' do
        before { subject.succeed! }

        it 'should raise StateMachines::InvalidTransition' do
          expect { subject.failure! }.to raise_error(StateMachines::InvalidTransition)
        end
      end

      context 'from state :failed' do
        before { subject.failure! }

        it 'should raise StateMachines::InvalidTransition' do
          expect { subject.failure! }.to raise_error(StateMachines::InvalidTransition)
        end
      end
    end
  end
end
