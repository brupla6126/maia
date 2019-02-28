require 'araignee/ai/core/repeater'
require 'spec_helpers/ai_helpers'

RSpec.describe Araignee::Ai::Core::Repeater do
  include Araignee::Ai::Helpers

  let(:child) { Araignee::Ai::Helpers::NodeFailed.new }
  let(:repeater) { described_class.new(child: child) }

  before do
    child.state = initial_state
    repeater.state = initial_state
  end

  subject { repeater }

  describe '#initialize' do
    it 'sets child' do
      expect(repeater.child).to eq(child)
    end
  end

  describe '#process' do
    let(:request) { OpenStruct.new }

    subject { repeater.process(request) }

    context 'calling repeater#repeat' do
      it 'repeater#repeat is called' do
        expect(repeater).to receive(:repeat).with(child, request)
        subject
      end
    end

    it 'has succeeded' do
      expect(subject.succeeded?).to eq(true)
    end
  end
end
