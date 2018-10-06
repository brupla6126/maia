require 'araignee/ai/core/fabricators/ai_parallel_fabricator'

RSpec.describe 'AI ParallelFabricator' do
  let(:parallel) { Fabricate(:ai_parallel) }

  subject { parallel }

  describe '#initialize' do
    it 'should have no child' do
      expect(subject.children).to eq([])
    end
  end
end
