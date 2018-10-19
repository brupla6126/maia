require 'araignee/ai/core/node'
require 'araignee/ai/core/pickers/picker'

RSpec.describe Araignee::Ai::Core::Pickers::Picker do
  let(:nodes) { (1..3).map { Araignee::Ai::Core::Node.new } }
  let(:picker) { described_class.new }

  subject { picker }

  describe 'pick' do
    subject { super().pick(nodes) }

    it 'returns all nodes' do
      expect(subject).to eq(nodes)
    end
  end
end
