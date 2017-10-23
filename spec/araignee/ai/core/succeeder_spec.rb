require 'araignee/ai/core/fabricators/ai_node_fabricator'
require 'araignee/ai/core/fabricators/ai_succeeder_fabricator'

RSpec.describe Ai::Core::Succeeder do
  let(:world) { {} }
  let(:entity) { {} }

  let(:succeeder) { Fabricate(:ai_succeeder, child: child) }
  let(:child) { Fabricate(:ai_node_succeeded) }

  subject { succeeder }

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

    before { succeeder.start! }
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
      let(:child) { Fabricate(:ai_node_failed) }

      it 'child is processed' do
        expect(child).to receive(:execute).with(entity, world)
      end

      it 'has succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end
  end
end
