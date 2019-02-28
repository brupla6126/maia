require 'araignee/ai/core/succeeder'
require 'spec_helpers/ai_helpers'

RSpec.describe Araignee::Ai::Core::Succeeder do
  include Araignee::Ai::Helpers

  let(:node_failed) { Araignee::Ai::Helpers::NodeFailed.new }
  let(:node_succeeded) { Araignee::Ai::Helpers::NodeSucceeded.new }

  let(:child) { node_succeeded }

  let(:succeeder) { described_class.new(child: child) }

  before do
    initialize_state(succeeder)
    initialize_state(child)
  end

  subject { succeeder }

  describe '#initialize' do
    it 'has its child set' do
      expect(subject.child).to eq(child)
    end
  end

  describe '#process' do
    let(:request) { OpenStruct.new }

    subject { super().process(request) }

    context 'when child response :succeeded' do
      it 'child is processed' do
        expect(child).to receive(:execute).with(request)
        subject
      end

      it 'has succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when child response :failed' do
      let(:child) { node_failed }

      it 'child is processed' do
        expect(child).to receive(:execute).with(request)
        subject
      end

      it 'has succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end
  end
end
