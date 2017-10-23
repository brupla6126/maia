require 'araignee/ai/core/fabricators/ai_node_fabricator'
require 'araignee/ai/core/sorters/sorter_random'

RSpec.describe Ai::Core::Sorters::SorterRandom do
  let(:sorter) { described_class.new }

  let(:nodes) { [Fabricate(:ai_node), Fabricate(:ai_node), Fabricate(:ai_node)] }

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
