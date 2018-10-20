require 'timecop'
require 'araignee/ai/core/node'

RSpec.describe Araignee::Ai::Core::Node do
  let(:world) { {}  }
  let(:entity) { {} }

  let(:attributes) { {} }

  let(:node) { described_class.new(attributes) }

  subject { node }

  describe '#initialize' do
    let(:identifier) { 'abcdef' }
    let(:attributes) { { identifier: identifier } }

    it 'sets identifier' do
      expect(subject.identifier).to eq(identifier)
    end

    it 'sets response to :unknown' do
      expect(subject.response).to eq(:unknown)
    end
  end

  describe '#process' do
    subject { super().process(entity, world) }

    before { node.start! }

    it 'returns self' do
      expect(subject).to eq(node)
    end

    it 'calls execute with entity, world and emits processing events' do
      expect(node).to receive(:emit).with(:ai_node_processing, node)
      expect(node).to receive(:execute).with(entity, world)
      expect(node).to receive(:emit).with(:ai_node_processed, node)
      subject
    end
  end

  describe 'busy?' do
    subject { super().busy? }

    before { node.response = :busy }

    it 'returns true' do
      expect(subject).to be_truthy
    end
  end

  describe 'failed?' do
    before { subject.response = :failed }

    it 'returns true' do
      expect(subject.failed?).to be_truthy
    end
  end

  describe 'succeeded?' do
    before { subject.response = :succeeded }

    it 'returns true' do
      expect(subject.succeeded?).to be_truthy
    end
  end

  describe '#reset' do
    subject { node.reset }

    before { node.response = :busy }

    it 'resets response to default value' do
      subject

      expect(node.response).to eq(:unknown)
    end
  end
end
