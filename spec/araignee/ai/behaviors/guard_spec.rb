require 'araignee/ai/actions/failed'
require 'araignee/ai/actions/running'
require 'araignee/ai/actions/succeeded'
require 'araignee/ai/behaviors/guard'
require 'araignee/ai/decisions/assertion'

include AI::Actions

RSpec.describe AI::Behaviors::Guard do
  class AssertionImplemented < AI::Decisions::Assertion
    def assert(_entity, _world)
      :succeeded
    end
  end

  let(:world) { double('[world]') }
  let(:entity) { { number: 0 } }

  let(:assertion) { AssertionImplemented.new }
  let(:guarded) { ActionSucceeded.new }

  let(:nodes) { [assertion, guarded] }

  let(:guard) { AI::Behaviors::Guard.new(nodes: nodes) }

  before { allow(world).to receive(:delta) { 1 } }

  describe '#initialize' do
    context 'when assertion, guarded are set' do
      let(:guarded) { ActionSucceeded.new }

      it 'assertion, guarded, no should be set' do
        expect(guard.child(assertion.identifier)).to eq(assertion)
        expect(guard.child(guarded.identifier)).to eq(guarded)
      end
    end
  end

  describe '#process' do
    before { guard.start! }
    before { allow(guarded).to receive(:process).and_return(guarded) }

    subject { guard.process(entity, world) }

    context 'when assertion resolve to :succeeded' do
      context 'when executed node state is :running' do
        before { subject }

        it 'guarded node should be processed' do
          expect(guarded).to have_received(:process)
        end

        it 'should have succeeded' do
          expect(subject.succeeded?).to eq(true)
        end
      end

      context 'when executed node state is :failed' do
        before { allow(guarded).to receive(:state_name).and_return(:failed) }
        before { subject }

        it 'should be failed' do
          expect(subject.failed?).to eq(true)
        end
      end

      context 'when executed node state is :running' do
        before { allow(guarded).to receive(:state_name).and_return(:running) }
        before { subject }

        it 'should be running' do
          expect(subject.running?).to eq(true)
        end
      end
    end

    context 'when assertion resolve to :failed' do
      before { allow_any_instance_of(AssertionImplemented).to receive(:assert).and_return(:failed) }
      before { subject }

      it 'guarded node should not be processed' do
        expect(guarded).not_to have_received(:process)
      end

      it 'should have succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end
  end
end
