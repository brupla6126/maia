require 'araignee/ai/core/fabricators/ai_failer_fabricator'

RSpec.describe 'AI FailerFabricator' do
  let(:failer) { Fabricate(:ai_failer) }

  subject { failer }

  describe '#initialize' do
    it 'should have no child' do
      expect(subject.child).to eq(nil)
    end
  end
end
