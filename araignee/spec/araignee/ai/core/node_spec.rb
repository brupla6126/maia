require 'timecop'
require 'araignee/ai/core/node'

RSpec.describe Araignee::Ai::Core::Node do
  let(:world) { {}  }
  let(:entity) { {} }

  let(:node) { described_class.new }

  subject { node }

  describe '#initialize' do
    let(:secure_random_hex) { 'abcdef' }

    before { allow(SecureRandom).to receive(:hex) { secure_random_hex } }

    it 'sets response to :unknown' do
      expect(node.response).to eq(:unknown)
    end

    it 'sets identifier from SecureRandom.hex' do
      expect(SecureRandom).to receive(:hex)
      expect(node.identifier).to eq(secure_random_hex)
    end

    context 'with attributes' do
      let(:identifier) { 'abcdef' }
      let(:node) { Araignee::Ai::Core::Node.new(identifier: identifier) }

      before { subject }

      it 'sets identifier' do
        expect(node.identifier).to eq(identifier)
      end
    end

    context 'with attributes' do
      let(:identifier) { 'abcdefg' }
      let(:node) { Araignee::Ai::Core::Node.new(identifier: identifier) }

      before { subject }

      it 'sets identifier' do
        expect(node.identifier).to eq(identifier)
      end
    end
  end

  describe 'validate_attributes' do
    subject { super().validate_attributes }

    context 'invalid identifier' do
      let(:identifier) { Araignee::Ai::Core::Node.new }
      let(:node) { Araignee::Ai::Core::Node.new(identifier: identifier) }

      it 'raises ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, 'invalid identifier')
      end
    end
  end

  describe '#process' do
    subject { super().process(entity, world) }

    before { node.start! }

    it 'returns self' do
      expect(subject).to eq(node)
    end

    it 'calls execute with entity and world' do
      expect(node).to receive(:execute).with(entity, world)
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

  describe '#reset_node' do
    subject { node.reset_node }

    before { node.start! }

    it 'resets response to default value' do
      subject

      expect(node.response).to eq(:unknown)
    end
  end

  describe 'update_response' do
    context 'invalid response' do
      it 'raises ArgumentError' do
        expect { subject.send(:update_response, nil) }.to raise_error(ArgumentError, 'invalid response: ')
        expect { subject.send(:update_response, :done) }.to raise_error(ArgumentError, 'invalid response: done')
      end
    end

    context 'valid response' do
      let(:responses) { %i[busy failed succeeded] }

      it 'updates response' do
        responses.each do |response|
          expect { subject.send(:update_response, response) }.not_to raise_error
          expect(subject.response).to eq(response)
        end
      end
    end
  end
end
