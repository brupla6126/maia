require 'araignee/ai/core/decorator'

RSpec.describe Ai::Core::Decorator do
  let(:decorated) { Ai::Core::Node.new }
  let(:decorator) { described_class.new(child: decorated) }

  subject { decorator }

  describe '#initialize' do
    it 'response is :unknown' do
      expect(subject.child.response).to eq(:unknown)
    end
  end
end
