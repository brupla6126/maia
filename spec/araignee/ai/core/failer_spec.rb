require 'araignee/ai/core/fabricators/ai_node_fabricator'
require 'araignee/ai/core/fabricators/ai_failer_fabricator'

RSpec.describe Ai::Core::Failer do
  let(:world) { {} }
  let(:entity) { {} }

  let(:failer) { Fabricate(:ai_failer, child: child) }
  let(:child) { Fabricate(:ai_node_succeeded) }

  subject { failer }

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

    before { failer.start! }
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
      let(:child) { Fabricate(:ai_node_failed) }

      it 'child is processed' do
        expect(child).to receive(:execute).with(entity, world)
      end

      it 'has failed' do
        expect(subject.failed?).to eq(true)
      end
    end
  end
end
