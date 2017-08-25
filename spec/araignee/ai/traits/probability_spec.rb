require 'araignee/ai/traits/probability'

RSpec.describe AI::Traits::Probability do
  class ProbabilityNode
    include AI::Traits::Probability
  end

  let(:node) { ProbabilityNode.new }

  it 'default value set to 0' do
    expect(node.probability).to eq(0)
  end

  describe '#probability' do
    let(:probability) { 80 }

    before { node.probability = probability }

    subject { node }

    it 'should be set' do
      expect(subject.probability).to eq(probability)
    end
  end
end
