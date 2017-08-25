require 'araignee/ai/leaf'

RSpec.describe AI::Leaf do
  let(:leaf) { AI::Leaf.new }

  describe '#initialize' do
    it 'should not raise error' do
      expect { leaf }.not_to raise_error
    end
  end
end
