require 'araignee/ai/actions/failed'
require 'araignee/ai/actions/busy'
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
  let(:entity) { {} }
  before { allow(world).to receive(:delta) { 1 } }

  let(:assertion) { AssertionImplemented.new({}) }
  let(:guarded) { ActionSucceeded.new({}) }

  let(:nodes) { [assertion, guarded] }

  let(:guard) { AI::Behaviors::Guard.new(nodes: nodes) }

  describe '#initialize' do
    context 'when assertion, guarded are set' do
      let(:guarded) { ActionSucceeded.new({}) }

      it 'assertion, guarded should be set' do
        expect(guard.child(assertion.identifier)).to eq(assertion)
        expect(guard.child(guarded.identifier)).to eq(guarded)
      end
    end
  end

  describe '#process' do
    subject { guard.process(entity, world) }

    before { guard.start! }
    before { allow(guarded).to receive(:process).and_return(guarded) }
    before { allow(guarded).to receive(:response).and_return(response) }

    let(:response) { :succeeded }
 
    context 'when assertion resolve to :succeeded' do
      before { subject }

      context 'when executed node response is :busy' do
        it 'guarded node should be processed' do
          expect(guarded).to have_received(:process)
        end

        it 'should have succeeded' do
          expect(subject.succeeded?).to eq(true)
        end
      end

      context 'when executed node response is :failed' do
        let(:response) { :failed }

        it 'should be failed' do
          allow(guarded).to receive(:response).and_return(:failed)
          expect(subject.failed?).to eq(true)
        end
      end

      context 'when executed node response is :busy' do
        let(:response) { :busy }

        it 'should be busy' do
          expect(subject.busy?).to eq(true)
        end
      end
    end

    context 'when assertion resolve to :failed' do
      before { allow(assertion).to receive(:assert).and_return(:failed) }

      it 'guarded node should not be processed' do
        expect(guarded).not_to have_received(:process)
      end

      it 'should have succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end
  end
end
