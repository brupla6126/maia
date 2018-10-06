require 'araignee/ai/core/fabricators/ai_sequence_fabricator'

RSpec.describe 'AI SequenceFabricator' do
  let(:sequence) { Fabricate(:ai_sequence) }

  subject { sequence }

  describe '#initialize' do
    it 'has no children' do
      expect(subject.children.empty?).to eq(true)
    end
  end
end
