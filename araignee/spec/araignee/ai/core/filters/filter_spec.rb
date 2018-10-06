require 'araignee/ai/core/fabricators/ai_node_fabricator'
require 'araignee/ai/core/filters/filter'

RSpec.describe Ai::Core::Filters::Filter do
  let(:node1) { Fabricate(:ai_node) }
  let(:node2) { Fabricate(:ai_node) }
  let(:nodes) { [node1, node2] }
  let(:filter) { described_class.new }

  subject { filter }

  describe 'accept' do
    subject { super().accept(nodes) }

    it 'returns nodes' do
      expect(subject).to eq([])
    end
  end

  describe 'reject' do
    subject { super().reject(nodes) }

    it 'returns empty array nodes' do
      expect(subject).to eq([])
    end
  end
end
