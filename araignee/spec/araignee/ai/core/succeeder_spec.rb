require 'araignee/ai/core/succeeder'

RSpec.describe Ai::Core::Succeeder do
  let(:world) { {} }
  let(:entity) { {} }

  let(:node_failed) { Ai::Core::Node.new }
  let(:node_succeeded) { Ai::Core::Node.new }

  let(:child) { node_succeeded }

  let(:succeeder) { described_class.new(child: child) }

  subject { succeeder }

  before { allow(node_failed).to receive(:response) { :failed } }
  before { allow(node_succeeded).to receive(:response) { :succeeded } }

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

      it 'has succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when action :failed' do
      let(:child) { node_failed }

      it 'child is processed' do
        expect(child).to receive(:execute).with(entity, world)
      end

      it 'has succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end
  end
end
