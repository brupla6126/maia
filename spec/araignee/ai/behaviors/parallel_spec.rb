require 'araignee/ai/actions/failed'
require 'araignee/ai/actions/stopped'
require 'araignee/ai/actions/succeeded'
require 'araignee/ai/behaviors/parallel'

include AI::Actions

RSpec.describe AI::Behaviors::Parallel do
  let(:world) { double('[world]') }
  let(:entity) { { number: 0 } }

  let(:completion) { 0 }
  let(:failures) { 0 }

  let(:nodes) { [ActionSucceeded.new, ActionFailed.new] }
  let(:parallel) { AI::Behaviors::Parallel.new(nodes: nodes, completion: completion, failures: failures) }

  before { allow(world).to receive(:delta) { 1 } }

  describe '#initialize' do
    context 'when attributes :completion and failures are not set' do
      it ':completion and failures should default to 0' do
        parallel = AI::Behaviors::Parallel.new(nodes: nodes)

        expect(parallel.completion).to eq(0)
        expect(parallel.failures).to eq(0)
      end
    end
  end

  describe '#start' do
    context 'when completion is set' do
      let(:completion) { -2 }

      it 'should raise ArgumentError, completion policy' do
        expect { parallel.start! }.to raise_error(ArgumentError, 'completion must be >= 0')
      end
    end

    context 'when failures is set' do
      let(:completion) { 0 }
      let(:failures) { -3 }

      it 'should raise ArgumentError, failures' do
        expect { parallel.start! }.to raise_error(ArgumentError, 'failures must be >= 0')
      end
    end

    context 'when completion and failures are equal' do
      let(:completion) { 1 }
      let(:failures) { 1 }

      it 'should raise ArgumentError, completion and failures must not equal' do
        expect { parallel.start! }.to raise_error(ArgumentError, 'completion and failures must not equal')
      end
    end
  end

  describe '#process' do
    before { parallel.start! }
    subject { parallel.process(entity, world) }

    context 'when ActionSucceeded, ActionFailed, ActionFailed, ActionStopped.new and :completion, :failures are not set' do
      let(:nodes) { [ActionSucceeded.new, ActionFailed.new, ActionFailed.new, ActionStopped.new] }

      it 'should stay running' do
        expect(subject.running?).to eq(true)
      end
    end

    context 'when ActionSucceeded, ActionFailed, ActionFailed and :completion = 1' do
      let(:completion) { 1 }
      let(:nodes) { [ActionSucceeded.new, ActionFailed.new, ActionFailed.new] }

      it 'should have succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when ActionSucceeded, ActionFailed, ActionFailed and :completion = 2' do
      let(:completion) { 2 }
      let(:nodes) { [ActionSucceeded.new, ActionFailed.new, ActionFailed.new] }

      it 'should be running' do
        expect(subject.running?).to eq(true)
      end
    end

    context 'when ActionSucceeded, ActionFailed, ActionFailed and :failures = Integer::MAX' do
      let(:completion) { 0 }
      let(:failures) { Integer::MAX }

      let(:nodes) { [ActionSucceeded.new, ActionFailed.new, ActionFailed.new] }

      it 'should stay running' do
        expect(subject.running?).to eq(true)
      end
    end

    context 'when ActionSucceeded, ActionFailed and :completion = Integer::MAX' do
      let(:completion) { Integer::MAX }
      let(:nodes) { [ActionSucceeded.new, ActionFailed.new] }

      it 'should stay running' do
        expect(subject.running?).to eq(true)
      end
    end

    context 'when ActionSucceeded, ActionFailed, ActionSucceeded and :failures = 1' do
      let(:failures) { 1 }

      let(:nodes) { [ActionSucceeded.new, ActionFailed.new, ActionSucceeded.new] }

      it 'should have failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when ActionSucceeded, ActionFailed, ActionFailed and :failures = 2' do
      let(:failures) { 2 }

      let(:nodes) { [ActionSucceeded.new, ActionFailed.new, ActionFailed.new] }

      it 'should have failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when ActionSucceeded, ActionFailed, ActionFailed and :failures = Integer::MAX' do
      let(:failures) { Integer::MAX }

      let(:nodes) { [ActionSucceeded.new, ActionFailed.new, ActionFailed.new] }

      it 'should stay running' do
        expect(subject.running?).to eq(true)
      end
    end

    context 'when ActionFailed, ActionFailed, ActionFailed and :failures = Integer::MAX' do
      let(:failures) { Integer::MAX }

      let(:nodes) { [ActionFailed.new, ActionFailed.new, ActionFailed.new] }

      it 'should have failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when ActionSucceeded, ActionFailed, ActionFailed, ActionFailed and :completion = 3, :failures = 2' do
      let(:completion) { 3 }
      let(:failures) { 2 }

      let(:nodes) { [ActionSucceeded.new, ActionFailed.new, ActionFailed.new, ActionFailed.new] }

      it 'should have failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when ActionFailed, ActionFailed, ActionFailed and :completion = 3' do
      let(:completion) { 3 }
      let(:failures) { Integer::MAX }

      let(:nodes) { [ActionFailed.new, ActionFailed.new, ActionFailed.new] }

      it 'should have failed' do
        expect(subject.failed?).to eq(true)
      end
    end
  end
end
