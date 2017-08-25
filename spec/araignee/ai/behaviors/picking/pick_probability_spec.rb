require 'araignee/ai/actions/probability'
require 'araignee/ai/behaviors/picking/pick_probability'

include AI::Actions

RSpec.describe AI::Behaviors::Picking::PickProbability do
  class PickingByProbability
    include AI::Behaviors::Picking::PickProbability
  end

  let(:picking) { PickingByProbability.new }

  describe '#pick_nodes' do
    subject { picking.pick_node(nodes) }

    let(:action1) { ActionLuckiest.new }
    let(:action2) { ActionBummer.new }
    let(:action3) { ActionLooser.new }

    context 'when no nodes' do
      let(:nodes) { [] }

      it 'should return nil' do
        expect(subject).to eq(nil)
      end
    end

    context 'when there are nodes' do
      let(:nodes) { [action1, action2, action3] }

      it 'should return a node' do
        expect(subject).not_to eq(nil)
        expect(subject.is_a?(AI::Node)).to eq(true)
      end
    end
  end
end
