require 'araignee/ai/core/fabricators/ai_node_fabricator'
require 'araignee/ai/core/fabricators/ai_inverter_fabricator'

RSpec.describe Ai::Core::Inverter do
  let(:world) { {} }
  let(:entity) { {} }

  let(:inverter) { Fabricate(:ai_inverter, child: child) }
  let(:child) { Fabricate(:ai_node_succeeded) }

  subject { inverter }

  describe '#initialize' do
    it 'is ready' do
      expect(subject.ready?).to eq(true)
    end

    it 'response is :unknown' do
      expect(subject.response).to eq(:unknown)
    end
  end

  describe '#process' do
    subject { super().process(entity, world) }

    before { inverter.start! }
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
      let(:child) { Fabricate(:ai_node_failed) }

      it 'has failed' do
        expect(subject.failed?).to eq(false)
      end
    end

    context 'when inverter processes a node that is busy' do
      let(:child) { Fabricate(:ai_node_busy) }

      it 'is busy' do
        expect(subject.busy?).to eq(true)
      end
    end
  end
end
