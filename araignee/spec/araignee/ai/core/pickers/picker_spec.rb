require 'araignee/ai/core/node'
require 'araignee/ai/core/pickers/picker'

RSpec.describe Araignee::Ai::Core::Pickers::Picker do
  let(:nodes) { (1..3).map { Araignee::Ai::Core::Node.new } }
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
