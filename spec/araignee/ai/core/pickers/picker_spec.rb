require 'araignee/ai/core/fabricators/ai_node_fabricator'
require 'araignee/ai/core/pickers/picker'

RSpec.describe Ai::Core::Pickers::Picker do
  let(:node1) { Fabricate(:ai_node) }
  let(:node2) { Fabricate(:ai_node) }
  let(:nodes) { [node1, node2] }
  let(:picker) { described_class.new }

  subject { picker }

  describe 'pick_one' do
    subject { super().pick_one(nodes) }

    it 'returns nil' do
      expect(subject).to eq(nil)
    end
  end

  describe 'pick_many' do
    subject { super().pick_many(nodes) }

    it 'returns all nodes' do
      expect(subject).to eq(nodes)
    end
  end
end
