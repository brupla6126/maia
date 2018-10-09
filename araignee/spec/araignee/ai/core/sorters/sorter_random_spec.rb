require 'araignee/ai/core/node'
require 'araignee/ai/core/sorters/sorter_random'

RSpec.describe Ai::Core::Sorters::SorterRandom do
  let(:sorter) { described_class.new }

  let(:nodes) { [Ai::Core::Node.new, Ai::Core::Node.new, Ai::Core::Node.new] }

  describe '#sort' do
    subject { sorter.sort(nodes) }

    it 'returns nodes sorted randomly' do
      # cannot verify nodes order since they are ordered at random
      expect(subject).to match_array(nodes)
    end

    context 'with nodes empty' do
      let(:nodes) { [] }

      it 'return nodes' do
        expect(subject).to eq(nodes)
      end
    end
  end
end
