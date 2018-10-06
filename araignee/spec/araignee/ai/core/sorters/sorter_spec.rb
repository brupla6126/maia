require 'araignee/ai/core/fabricators/ai_node_fabricator'
require 'araignee/ai/core/sorters/sorter'

RSpec.describe Ai::Core::Sorters::Sorter do
  let(:node1) { Fabricate(:ai_node) }
  let(:node2) { Fabricate(:ai_node) }
  let(:nodes) { [node1, node2] }
  let(:sorter) { described_class.new }

  subject { sorter }

  describe 'sort' do
    subject { super().sort(nodes) }

    it 'returns nodes as passed in' do
      expect(subject).to eq(nodes)
    end
  end
end
