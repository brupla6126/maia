require 'araignee/ai/actions/failed'
require 'araignee/ai/actions/succeeded'
require 'araignee/ai/behaviors/inverter'

include AI::Actions

RSpec.describe AI::Behaviors::Inverter do
  let(:world) { double('[world]') }
  let(:entity) { { number: 0 } }

  let(:action_success) { ActionSucceeded.new }
  let(:action_failure) { ActionFailed.new }
  let(:node) { action_success }
  let(:inverter) { AI::Behaviors::Inverter.new(node: node) }

  before { allow(world).to receive(:delta) { 1 } }

  describe '#process' do
    before { inverter.start! }
    subject { inverter.process(entity, world) }

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

    it 'returns self' do
      expect(subject).to eq(inverter)
    end
  end
end
