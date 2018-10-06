require 'araignee/ai/core/fabricators/ai_stopper_fabricator'

RSpec.describe 'AI StopperFabricator' do
  let(:stopper) { Fabricate(:ai_stopper) }

  subject { stopper }

  describe '#initialize' do
    it 'should have no child' do
      expect(subject.child).to eq(nil)
    end
  end
end
