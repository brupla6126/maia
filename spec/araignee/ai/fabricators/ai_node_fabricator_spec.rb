require 'araignee/ai/fabricators/ai_node_fabricator'

RSpec.describe 'AI NodeFabricator' do
  let(:node) { Fabricate(:ai_node) }

  subject { node }

  describe '#initialize' do
    context 'with attributes empty' do
      it 'recorder should be nil' do
        expect(subject.recorder).to be(nil)
      end
    end
  end
end

RSpec.describe 'AI NodeFabricator Recorded' do
  let(:node) { Fabricate(:ai_node_recorded) }

  subject { node }

  describe '#initialize' do
    it 'recorder should not be nil' do
      expect(subject.recorder).not_to be(nil)
    end
  end
end
