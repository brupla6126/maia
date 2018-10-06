require 'araignee/ai/core/fabricators/ai_guard_fabricator'

RSpec.describe 'AI GuardFabricator' do
  let(:guard) { Fabricate(:ai_guard) }

  subject { guard }

  describe '#initialize' do
    it 'should have no child' do
      expect(subject.child).to eq(nil)
    end
  end
end
