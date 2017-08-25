require 'araignee/ai/actions/succeeded'
require 'araignee/ai/behaviors/ordering/order_priority'

include AI::Actions

class OrderingByPriority
  include AI::Behaviors::Ordering::OrderPriority
end

RSpec.describe AI::Behaviors::Ordering::OrderPriority do
  let(:ordering) { OrderingByPriority.new }

  describe '#order_nodes' do
    subject { ordering.order_nodes(nodes, reverse) }

    let(:reverse) { false }

    let(:action1) { ActionSucceeded.new(priority: 10) }
    let(:action2) { ActionSucceeded.new(priority: 15) }
    let(:action3) { ActionSucceeded.new(priority: 5) }
    let(:nodes) { [action1, action2, action3] }

    context 'when ascending order' do
      let(:reverse) { false }

      it 'nodes should have been ordered properly' do
        expect(subject[0]).to eq(action3)
        expect(subject[1]).to eq(action1)
        expect(subject[2]).to eq(action2)
      end
    end

    context 'when descending order' do
      let(:reverse) { true }

      it 'nodes should have been ordered properly' do
        expect(subject[0]).to eq(action2)
        expect(subject[1]).to eq(action1)
        expect(subject[2]).to eq(action3)
      end
    end
  end
end
