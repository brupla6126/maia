require 'araignee/ai/core/node'
require 'araignee/ai/core/sorters/sorter'

RSpec.describe Araignee::Ai::Core::Sorters::Sorter do
  let(:nodes) { (1..3).map { Araignee::Ai::Core::Node.new } }
  let(:sorter) { described_class.new }

  subject { sorter }

  describe 'sort' do
    subject { super().sort(nodes) }

    it 'returns nodes as passed in' do
      expect(subject).to eq(nodes)
    end
  end
end
