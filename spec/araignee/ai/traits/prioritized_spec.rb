require 'araignee/ai/traits/prioritized'

RSpec.describe AI::Traits::Prioritized do
  class PrioritizedNode
    include AI::Traits::Prioritized
  end

  let(:node) { PrioritizedNode.new }

  subject { node.prioritize(delta) }

  it 'default value set to 0' do
    expect(node.priority).to eq(0)
  end

  describe '#prioritize' do
    before { subject }

    context 'positive delta' do
      let(:delta) { 5 }

      it 'should increment' do
        expect(node.priority).to eq(5)
      end
    end

    context 'negative delta' do
      let(:delta) { -15 }

      it 'should decrement' do
        expect(node.priority).to eq(-15)
      end
    end
  end
end
