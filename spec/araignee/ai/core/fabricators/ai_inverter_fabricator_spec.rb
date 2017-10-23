require 'araignee/ai/core/fabricators/ai_inverter_fabricator'

RSpec.describe 'AI InverterFabricator' do
  let(:inverter) { Fabricate(:ai_inverter) }

  subject { inverter }

  describe '#initialize' do
    it 'should have no child' do
      expect(subject.child).to eq(nil)
    end
  end
end
