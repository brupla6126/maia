require 'araignee/ai/core/inverter'

RSpec.describe Ai::Core::Inverter do
  let(:world) { {} }
  let(:entity) { {} }

  let(:inverter) { described_class.new(child: child) }
  let(:child) { Ai::Core::Node.new }

  let(:node_busy) { Ai::Core::Node.new }
  let(:node_failed) { Ai::Core::Node.new }
  let(:node_succeeded) { Ai::Core::Node.new }

  subject { inverter }

  before { allow(child).to receive(:response) { :succeeded } }
  before { allow(node_busy).to receive(:response) { :busy } }
  before { allow(node_failed).to receive(:response) { :failed } }
  before { allow(node_succeeded).to receive(:response) { :succeeded } }

  describe '#initialize' do
    it 'response is :unknown' do
      expect(subject.response).to eq(:unknown)
    end
  end

  describe '#process' do
    subject { super().process(entity, world) }

    after { subject }

    context 'child is processed' do
      before { allow(child).to receive(:process).with(entity, world) { child } }
      before { allow(child).to receive(:response) { :succeeded } }

      it 'child is processed' do
        expect(child).to receive(:process).with(entity, world)
      end
    end

    context 'when inverter processes a node that succeeded' do
      it 'has failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when inverter processes a node that failed' do
      let(:child) { node_failed }

      it 'has not failed' do
        expect(subject.failed?).to eq(false)
      end
    end

    context 'when inverter processes a node that is busy' do
      let(:child) { node_busy }

      it 'is busy' do
        expect(subject.busy?).to eq(true)
      end
    end
  end
end
