require 'araignee/ai/fabricators/ai_decorator_fabricator'

RSpec.describe 'AI DecoratorFabricator' do
  let(:decorator) { Fabricate(:ai_decorator) }

  subject { decorator }

  describe '#initialize' do
    it 'should have no child' do
      expect(subject.child).to eq(nil)
    end
  end
end
