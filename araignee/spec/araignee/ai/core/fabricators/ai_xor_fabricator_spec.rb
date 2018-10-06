require 'araignee/ai/core/fabricators/ai_xor_fabricator'

RSpec.describe 'AI XorFabricator' do
  let(:xor) { Fabricate(:ai_xor) }

  subject { xor }

  describe '#initialize' do
    it 'has no children' do
      expect(subject.children.empty?).to eq(true)
    end
  end
end
