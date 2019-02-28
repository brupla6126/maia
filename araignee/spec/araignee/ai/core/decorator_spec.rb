require 'araignee/ai/core/decorator'
require 'spec_helpers/ai_helpers'

RSpec.describe Araignee::Ai::Core::Decorator do
  include Araignee::Ai::Helpers

  let(:decorated) { Araignee::Ai::Helpers::NodeSucceeded.new }
  let(:decorator) { described_class.new(child: decorated) }

  subject { decorator }

  describe '#initialize' do
    it 'child is set' do
      expect(subject.child).to eq(decorated)
    end
  end
end
