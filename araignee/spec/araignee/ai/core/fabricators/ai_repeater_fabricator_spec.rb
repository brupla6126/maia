require 'araignee/ai/core/fabricators/ai_repeater_fabricator'

RSpec.describe 'AI RepeaterFabricator' do
  let(:repeater) { Fabricate(:ai_repeater) }

  subject { repeater }

  describe '#initialize' do
    it 'should have no child' do
      expect(subject.child).to eq(nil)
    end
  end
end
