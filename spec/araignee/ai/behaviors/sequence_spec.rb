require 'araignee/ai/actions/failed'
require 'araignee/ai/actions/busy'
require 'araignee/ai/actions/succeeded'
require 'araignee/ai/behaviors/sequence'

include AI::Actions

RSpec.describe AI::Behaviors::Sequence do
  let(:world) { double('[world]') }
  let(:entity) { {} }
  before { allow(world).to receive(:delta) { 1 } }

  let(:nodes) { [] }
  let(:sequence) { AI::Behaviors::Sequence.new(nodes: nodes) }

  describe '#process' do
    subject { sequence.process(entity, world) }
    before { sequence.start! }

    let(:nodes) { [ActionSucceeded.new({})] }

    context 'when nodes = ActionSucceeded, ActionSucceeded' do
      let(:nodes) { [ActionSucceeded.new({}), ActionSucceeded.new({})] }

      it 'should have succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when nodes = ActionSucceeded, ActionBusy, ActionSucceeded' do
      let(:nodes) { [ActionSucceeded.new({}), ActionBusy.new({}), ActionSucceeded.new({})] }

      it 'should be busy' do
        expect(subject.busy?).to eq(true)
      end
    end

    context 'when nodes = ActionFailed, ActionSucceeded' do
      let(:nodes) { [ActionFailed.new({}), ActionSucceeded.new({})] }

      it 'should have failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    it 'returns self' do
      expect(subject).to eq(sequence)
    end
  end
end
