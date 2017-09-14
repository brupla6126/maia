require 'araignee/ai/actions/probability'
require 'araignee/ai/behaviors/ordering/order_random'

include AI::Actions

class OrderingAtRandom
  include AI::Behaviors::Ordering::OrderRandom
end

RSpec.describe AI::Behaviors::Ordering::OrderRandom do
  let(:ordering) { OrderingAtRandom.new }

  describe '#order_nodes' do
    subject { ordering.order_nodes(nodes) }

    let(:action1) { ActionLuckiest.new({}) }
    let(:action2) { ActionLooser.new({}) }
    let(:action3) { ActionBummer.new({}) }
    let(:nodes) { [action1, action2, action3] }

    it 'nodes should have been ordered' do
      # cannot verify nodes since they are ordered at random
      expect(subject.include?(action1)).to eq(true)
      expect(subject.include?(action2)).to eq(true)
      expect(subject.include?(action3)).to eq(true)
    end
  end
end
