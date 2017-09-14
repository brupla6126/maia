require 'araignee/ai/actions/failed'
require 'araignee/ai/actions/busy'
require 'araignee/ai/actions/succeeded'
require 'araignee/ai/behaviors/inverter'

include AI::Actions

RSpec.describe AI::Behaviors::Inverter do
  let(:world) { double('[world]') }
  let(:entity) { {} }
  before { allow(world).to receive(:delta) { 1 } }

  let(:action_success) { ActionSucceeded.new({}) }
  let(:action_failure) { ActionFailed.new({}) }
  let(:action_busy) { ActionBusy.new({}) }
  let(:node) { action_success }
  let(:inverter) { AI::Behaviors::Inverter.new(node: node) }


  describe '#process' do
    subject { inverter.process(entity, world) }
    before { inverter.start! }

    context 'when inverter processes a node that succeeded' do
      let(:node) { action_success }

      it 'should have failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when inverter processes a node that failed' do
      let(:node) { action_failure }

      it 'should have failed' do
        expect(subject.failed?).to eq(false)
      end
    end

    context 'when inverter processes a node that is busy' do
      let(:node) { action_busy }

      it 'should be busy' do
        expect(subject.busy?).to eq(true)
      end
    end

    it 'returns self' do
      expect(subject).to eq(inverter)
    end
  end
end
