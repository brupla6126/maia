require 'araignee/ai/fabricators/ai_composite_fabricator'

RSpec.describe 'AI CompositeFabricator' do
  let(:composite) { Fabricate(:ai_composite) }

  subject { composite }

  describe '#initialize' do
    it 'should have no children' do
      expect(subject.children.empty?).to eq(true)
    end
  end
end
