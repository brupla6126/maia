require 'araignee/ai/core/fabricators/ai_timeout_fabricator'

RSpec.describe 'AI TimeoutFabricator' do
  let(:timeout) { Fabricate(:ai_timeout) }

  subject { timeout }

  describe '#initialize' do
    it 'sets delay to zero' do
      expect(subject.delay).to eq(0)
    end
  end
end
