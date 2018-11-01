require 'araignee/ai/core/decorator'

RSpec.describe Araignee::Ai::Core::Decorator do
  let(:decorated) { Araignee::Ai::Core::NodeSucceeded.new }
  let(:decorator) { described_class.new(child: decorated) }

  subject { decorator }

  describe '#initialize' do
    it 'child is set' do
      expect(subject.child).to eq(decorated)
    end
  end
end
