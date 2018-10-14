require 'araignee/ai/core/node'
require 'araignee/ai/core/filters/filter'

RSpec.describe Araignee::Ai::Core::Filters::Filter do
  let(:node1) { Araignee::Ai::Core::Node.new }
  let(:node2) { Araignee::Ai::Core::Node.new }
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
