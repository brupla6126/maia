require 'timecop'
require 'araignee/ai/core/node'

RSpec.describe Araignee::Ai::Core::Node do
  let(:attributes) { {} }

  let(:node) { described_class.new(attributes) }

  let(:request) { OpenStruct.new(world: {}, entity: {}) }

  before do
    node.on(:ai_node_processing) do |params|
      emitter = params[0]
      emitter.state = initial_state
    end

    node.on(:ai_node_processed) do |params|
      emitter = params[0]
      emitter.state = busy_state
    end

    node.on(:ai_node_resetting) do |params|
      emitter = params[0]
      emitter.state = initial_state
    end
  end

  subject { node }

  describe '#initialize' do
    let(:identifier) { 'abcdef' }
    let(:attributes) { { identifier: identifier } }

    it 'sets identifier' do
      expect(subject.identifier).to eq(identifier)
    end
  end

  describe '#process' do
    subject { super().process(request) }

    it 'returns self' do
      expect(subject).to eq(node)
    end

    it 'calls execute with request and emits processing events' do
      expect(node).to receive(:execute).with(request)
      subject
      expect(node.state).to eq(busy_state)
    end
    # TODO: process twice to check for current state
  end

  describe 'busy?' do
    subject { super().busy? }

    before do
      node.process(request)
      node.state = busy_state
    end

    it 'returns true' do
      expect(subject).to be_truthy
    end
  end

  describe 'failed?' do
    subject { super().failed? }

    before do
      node.process(request)
      node.state = failed_state
    end

    it 'returns true' do
      expect(subject).to be_truthy
    end
  end

  describe 'succeeded?' do
    subject { super().succeeded? }

    before do
      node.process(request)
      node.state = succeeded_state
    end

    it 'returns true' do
      expect(subject).to be_truthy
    end
  end

  describe '#reset' do
    subject { super().reset }

    before do
      node.process(request)
      node.state = busy_state
    end

    it 'resets response to default value' do
      subject

      expect(node.state.response).to eq(:unknown)
    end
  end
end
