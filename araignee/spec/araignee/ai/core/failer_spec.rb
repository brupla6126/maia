require 'araignee/ai/core/failer'
require 'spec_helpers/ai_helpers'

RSpec.describe Araignee::Ai::Core::Failer do
  include Araignee::Ai::Helpers

  let(:child) { Araignee::Ai::Helpers::NodeSucceeded.new }
  let(:failer) { described_class.new(child: child) }

  before do
    initialize_state(failer)
    initialize_state(child)
  end

  subject { failer }

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

      it 'failer has failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when child response :failed' do
      let(:child) { Araignee::Ai::Helpers::NodeFailed.new }

      it 'child is processed' do
        expect(child).to receive(:execute).with(request)
        subject
      end

      it 'failer has failed' do
        expect(subject.failed?).to eq(true)
      end
    end
  end
end
