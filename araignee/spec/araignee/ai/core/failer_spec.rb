require 'araignee/ai/core/failer'

RSpec.describe Ai::Core::Failer do
  let(:world) { {} }
  let(:entity) { {} }

  let(:failer) { described_class.new(child: child) }
  let(:child) { Ai::Core::Node.new }

  subject { failer }

  before { allow(child).to receive(:response) { :succeeded } }

  describe '#initialize' do
    it 'response is :unknown' do
      expect(subject.response).to eq(:unknown)
    end
  end

  describe '#process' do
    subject { super().process(entity, world) }

    before { allow(child).to receive(:execute).with(entity, world) { child } }
    after { subject }

    context 'when action :succeeded' do
      it 'child is processed' do
        expect(child).to receive(:execute).with(entity, world)
      end

      it 'has failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when action :failed' do
      before { allow(child).to receive(:response) { :failed } }

      it 'child is processed' do
        expect(child).to receive(:execute).with(entity, world)
      end

      it 'has failed' do
        expect(subject.failed?).to eq(true)
      end
    end
  end
end
