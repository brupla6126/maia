require 'araignee/ai/actions/failed'
require 'araignee/ai/actions/running'
require 'araignee/ai/actions/succeeded'
require 'araignee/ai/behaviors/sequence'

include AI::Actions

RSpec.describe AI::Behaviors::Sequence do
  let(:world) { double('[world]') }

  let(:nodes) { [] }
  let(:sequence) { AI::Behaviors::Sequence.new(nodes: nodes) }
  let(:entity) { { number: 0 } }

  before { allow(world).to receive(:delta) { 1 } }

  describe '#process' do
    before { sequence.start! }
    subject { sequence.process(entity, world) }

    let(:nodes) { [ActionSucceeded.new] }

    context 'when nodes = ActionSucceeded, ActionSucceeded' do
      let(:nodes) { [ActionSucceeded.new, ActionSucceeded.new] }

      it 'should have succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when nodes = ActionSucceeded, ActionRunning, ActionSucceeded' do
      let(:nodes) { [ActionSucceeded.new, ActionRunning.new, ActionSucceeded.new] }

      it 'should be running' do
        expect(subject.running?).to eq(true)
      end
    end

    context 'when nodes = ActionFailed, ActionSucceeded' do
      let(:nodes) { [ActionFailed.new, ActionSucceeded.new] }

      it 'should have failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when nodes = ActionFailed, ActionSucceeded' do
      let(:succeeded_node) { ActionSucceeded.new }
      let(:nodes) { [ActionSucceeded.new, succeeded_node] }

      before { succeeded_node.succeed! }

      it 'should have failed' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    it 'returns self' do
      expect(subject).to eq(sequence)
    end
  end
end
