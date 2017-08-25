require 'araignee/ai/actions/canceled'
require 'araignee/ai/actions/failed'
require 'araignee/ai/actions/succeeded'
require 'araignee/ai/behaviors/parallel'

include AI::Actions

RSpec.describe AI::Behaviors::Parallel do
  let(:world) { double('[world]') }
  let(:entity) { { number: 0 } }

  let(:completion) { 0 }
  let(:failure) { 0 }

  let(:nodes) { [ActionSucceeded.new, ActionFailed.new] }
  let(:times) { nil }
  let(:parallel) { AI::Behaviors::Parallel.new(nodes: nodes, completion: completion, failure: failure) }

  before do
    allow(world).to receive(:delta) { 1 }
  end

  describe '#initialize' do
    context 'when attributes :completion and failure are not set' do
      it ':completion and failure should default to 0' do
        parallel = AI::Behaviors::Parallel.new(nodes: nodes)

        expect(parallel.completion).to eq(0)
        expect(parallel.failure).to eq(0)
      end
    end
  end

  describe '#start' do
    context 'when completion is set' do
      let(:completion) { -2 }

      it 'should raise ArgumentError, completion policy' do
        expect { parallel.fire_state_event(:start) }.to raise_error(ArgumentError, 'completion must be >= 0')
      end
    end

    context 'when failure is set' do
      let(:completion) { 0 }
      let(:failure) { -3 }

      it 'should raise ArgumentError, failure' do
        expect { parallel.fire_state_event(:start) }.to raise_error(ArgumentError, 'failure must be >= 0')
      end
    end

    context 'when completion and failure are equal' do
      let(:completion) { 1 }
      let(:failure) { 1 }

      it 'should raise ArgumentError, completion and failure must not equal' do
        expect { parallel.fire_state_event(:start) }.to raise_error(ArgumentError, 'completion and failure must not equal')
      end
    end
  end

  describe '#process' do
    before { parallel.fire_state_event(:start) }
    subject { parallel.process(entity, world) }

    context 'when ActionSucceeded, ActionFailed, ActionFailed, ActionCanceled.new and :completion, :failure are not set' do
      let(:nodes) { [ActionSucceeded.new, ActionFailed.new, ActionFailed.new, ActionCanceled.new] }

      it 'should stay running' do
        expect(subject.running?).to eq(true)
      end
    end

    context 'when ActionSucceeded, ActionFailed, ActionFailed and :completion => 1' do
      let(:completion) { Integer::MAX }
      let(:nodes) { [ActionSucceeded.new, ActionFailed.new, ActionFailed.new] }

      it 'should stay running' do
        expect(subject.running?).to eq(true)
      end
    end

    context 'when ActionSucceeded, ActionFailed, ActionFailed and :completion => 2' do
      let(:completion) { 2 }
      let(:nodes) { [ActionSucceeded.new, ActionFailed.new, ActionFailed.new] }

      it 'should stay running' do
        expect(subject.running?).to eq(true)
      end
    end

    context 'when ActionSucceeded, ActionFailed, ActionFailed and :failure => Integer::MAX' do
      let(:completion) { 0 }
      let(:failure) { Integer::MAX }

      let(:nodes) { [ActionSucceeded.new, ActionFailed.new, ActionFailed.new] }

      it 'should stay running' do
        expect(subject.running?).to eq(true)
      end
    end

    context 'when ActionSucceeded, ActionFailed and :completion => Integer::MAX' do
      let(:completion) { Integer::MAX }
      let(:nodes) { [ActionSucceeded.new, ActionFailed.new] }

      it 'should stay running' do
        expect(subject.running?).to eq(true)
      end
    end

    context 'when ActionSucceeded, ActionFailed, ActionSucceeded and :failure => 1' do
      let(:failure) { 1 }

      let(:nodes) { [ActionSucceeded.new, ActionFailed.new, ActionSucceeded.new] }

      it 'should have failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when ActionSucceeded, ActionFailed, ActionFailed and :failure => 2' do
      let(:failure) { 2 }

      let(:nodes) { [ActionSucceeded.new, ActionFailed.new, ActionFailed.new] }

      it 'should have failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when ActionSucceeded, ActionFailed, ActionFailed and :failure => Integer::MAX' do
      let(:failure) { Integer::MAX }

      let(:nodes) { [ActionSucceeded.new, ActionFailed.new, ActionFailed.new] }

      it 'should stay running' do
        expect(subject.running?).to eq(true)
      end
    end

    context 'when ActionFailed, ActionFailed, ActionFailed and :failure => Integer::MAX' do
      let(:failure) { Integer::MAX }

      let(:nodes) { [ActionFailed.new, ActionFailed.new, ActionFailed.new] }

      it 'should have failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when ActionSucceeded, ActionFailed, ActionFailed, ActionFailed and :completion => 3, :failure => 2' do
      let(:completion) { 3 }
      let(:failure) { 2 }

      let(:nodes) { [ActionSucceeded.new, ActionFailed.new, ActionFailed.new, ActionFailed.new] }

      it 'should have failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when ActionFailed, ActionFailed, ActionFailed and :completion => 3' do
      let(:completion) { 3 }
      let(:failure) { Integer::MAX }

      let(:nodes) { [ActionFailed.new, ActionFailed.new, ActionFailed.new] }

      it 'should have failed' do
        expect(subject.failed?).to eq(true)
      end
    end
  end
end
