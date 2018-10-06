require 'araignee/ai/core/fabricators/ai_ternary_fabricator'

RSpec.describe 'AI TernaryFabricator' do
  let(:ternary) { Fabricate(:ai_ternary) }

  subject { ternary }

  describe '#initialize' do
    it 'does not have interrogator node' do
      expect(subject.interrogator).to eq(nil)
    end

    it 'does not have yes node' do
      expect(subject.yes).to eq(nil)
    end

    it 'does not have no node' do
      expect(subject.no).to eq(nil)
    end
  end
end
