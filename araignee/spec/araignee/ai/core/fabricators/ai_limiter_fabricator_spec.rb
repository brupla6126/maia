require 'araignee/ai/core/fabricators/ai_limiter_fabricator'

RSpec.describe 'AI LimiterFabricator' do
  let(:limiter) { Fabricate(:ai_limiter) }

  subject { limiter }

  describe '#initialize' do
    it 'should have no child' do
      expect(subject.child).to eq(nil)
    end
  end
end
