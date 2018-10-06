require 'araignee/ai/core/fabricators/ai_interrogator_fabricator'

RSpec.describe 'AI InterrogatorFabricator' do
  let(:interrogator) { Fabricate(:ai_interrogator) }

  subject { interrogator }

  describe '#initialize' do
    it 'should have no child' do
      expect(subject.child).to eq(nil)
    end
  end
end
