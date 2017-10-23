require 'araignee/ai/core/fabricators/ai_succeeder_fabricator'

RSpec.describe 'AI SucceederFabricator' do
  let(:succeeder) { Fabricate(:ai_succeeder) }

  subject { succeeder }

  describe '#initialize' do
    it 'should have no child' do
      expect(subject.child).to eq(nil)
    end
  end
end
