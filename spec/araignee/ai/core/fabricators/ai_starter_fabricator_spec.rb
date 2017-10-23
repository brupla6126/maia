require 'araignee/ai/core/fabricators/ai_starter_fabricator'

RSpec.describe 'AI StarterFabricator' do
  let(:starter) { Fabricate(:ai_starter) }

  subject { starter }

  describe '#initialize' do
    it 'should have no child' do
      expect(subject.child).to eq(nil)
    end
  end
end
