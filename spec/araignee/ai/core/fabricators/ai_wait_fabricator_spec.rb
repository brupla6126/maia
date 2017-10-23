require 'araignee/ai/core/fabricators/ai_wait_fabricator'

RSpec.describe 'AI WaitFabricator' do
  let(:wait) { Fabricate(:ai_wait) }

  subject { wait }

  describe '#initialize' do
    it 'sets delay to zero' do
      expect(subject.delay).to eq(0)
    end
  end
end
