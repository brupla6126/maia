require 'araignee/ai/actions/failed'
require 'araignee/ai/actions/succeeded'
require 'araignee/ai/behaviors/picking/pick_random'

include AI::Actions

RSpec.describe AI::Behaviors::Picking::PickRandom do
  class PickingAtRandom
    include AI::Behaviors::Picking::PickRandom
  end

  let(:picking) { PickingAtRandom.new }

  describe '#pick_nodes' do
    subject { picking.pick_node(nodes) }

    context 'when no nodes' do
      let(:nodes) { [] }

      it 'should return nil' do
        expect(subject).to eq(nil)
      end
    end

    context 'when there are nodes' do
      let(:action1) { ActionSucceeded.new({}) }
      let(:action2) { ActionFailed.new({}) }

      let(:nodes) { [action1, action2] }

      it 'should return a node' do
        expect(subject).not_to eq(nil)
        expect(subject.is_a?(AI::Node)).to eq(true)
      end
    end
  end
end
