require 'timecop'
require 'araignee/ai/core/node'

RSpec.describe Ai::Core::Node do
  let(:world) { {}  }
  let(:entity) { {} }

  before { Log[:ai] = double('Log[:ai]') }
  before { allow(Log[:ai]).to receive(:debug) }
  after { Log[:ai] = Log[:default] }

  it { is_expected.to have_states(:ready, :running, :paused, :stopped, on: :state) }

  it { is_expected.to handle_events :start, when: :ready, on: :state }
  it { is_expected.to handle_events :start, when: :stopped, on: :state }
  it { is_expected.to handle_events :stop, when: :paused, on: :state }
  it { is_expected.to handle_events :stop, when: :running, on: :state }
  it { is_expected.to handle_events :pause, when: :running, on: :state }
  it { is_expected.to handle_events :resume, when: :paused, on: :state }

  let(:node) { described_class.new }

  subject { node }

  describe '#initialize' do
    let(:secure_random_hex) { 'abcdef' }
    before { allow(SecureRandom).to receive(:hex) { secure_random_hex } }

    it 'node is ready' do
      expect(node.ready?).to eq(true)
    end

    it 'sets response to :unknown' do
      expect(node.response).to eq(:unknown)
    end

    it 'sets identifier from SecureRandom.hex' do
      expect(SecureRandom).to receive(:hex)
      expect(node.identifier).to eq(secure_random_hex)
    end

    context 'with attributes' do
      let(:identifier) { 'abcdef' }
      let(:node) { Ai::Core::Node.new(identifier: identifier) }

      before { subject }

      it 'sets identifier' do
        expect(node.identifier).to eq(identifier)
      end
    end

    context 'with Virtus attributes' do
      context 'valid attributes' do
        let(:identifier) { 'abcdefg' }
        let(:node) { Ai::Core::Node.new(identifier: identifier) }

        before { subject }

        it 'sets identifier' do
          expect(node.identifier).to eq(identifier)
        end
      end
    end
  end

  describe 'validate_attributes' do
    subject { node.validate_attributes }

    context 'invalid identifier' do
      let(:identifier) { Ai::Core::Node.new }
      let(:node) { Ai::Core::Node.new(identifier: identifier) }

      it 'raises ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, 'invalid identifier')
      end
    end
  end

  describe '#can_stop?' do
    subject { node.can_stop? }

    context 'when state equals ready' do
      it 'returns false' do
        expect(subject).to eq(false)
      end
    end

    context 'when state equals running' do
      before { node.start! }

      it 'returns true' do
        expect(subject).to eq(true)
      end
    end

    context 'when state equals paused' do
      before { node.start! }
      before { node.pause! }

      it 'returns true' do
        expect(subject).to eq(true)
      end
    end
  end

  describe '#process' do
    subject { node.process(entity, world) }

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
    before { subject.response = :busy }

    it 'returns true' do
      expect(subject.busy?).to eq(true)
    end
  end

  describe 'failed?' do
    before { subject.response = :failed }

    it 'returns true' do
      expect(subject.failed?).to eq(true)
    end
  end

  describe 'succeeded?' do
    before { subject.response = :succeeded }

    it 'returns true' do
      expect(subject.succeeded?).to eq(true)
    end
  end

  describe '#reset_node' do
    subject { node.reset_node }

    before { node.start! }

    it 'resets response to default value' do
      subject

      expect(node.state).to eq('running')
      expect(node.response).to eq(:unknown)
    end
  end

  describe '#start!' do
    subject { super().start! }

    it 'calls Log[:ai].debug' do
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Starting: #{subject.inspect}") }
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Started: #{subject.inspect}") }

      subject
    end

    context 'node_starting' do
      context 'calling validate_attributes' do
        before { allow(node).to receive(:validate_attributes) }

        it 'calls validate_attributes' do
          expect(node).to receive(:validate_attributes)
          subject
        end
      end

      it 'is running' do
        subject
        expect(node.running?).to eq(true)
      end
    end

    context 'node_restarting' do
      before { node.start! }
      before { node.stop! }

      it 'calls Log[:ai].debug' do
        expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Restarting: #{subject.inspect}") }
        expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Restarted: #{subject.inspect}") }

        subject
      end

      it 'is running' do
        subject
        expect(node.running?).to eq(true)
      end

      context do
        before { allow(node).to receive(:reset_node) }
        before { allow(node).to receive(:validate_attributes) }
        after { subject }

        it 'resets node' do
          expect(node).to receive(:reset_node)
        end

        it 'validates attributes' do
          expect(node).to receive(:validate_attributes)
        end
      end
    end
  end

  describe '#stop!' do
    before { subject.start! }

    it 'calls Log[:ai].debug' do
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Stopping: #{subject.inspect}") }
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Stopped: #{subject.inspect}") }

      subject.stop!
    end

    #    it 'is stopped' do
    #      subject
    #      expect(node.running?).to eq(false)
    #      expect(node.stopped?).to eq(true)
    #    end
  end

  describe '#pause!' do
    before { subject.start! }

    it 'calls Log[:ai].debug' do
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Pausing: #{subject.inspect}") }
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Paused: #{subject.inspect}") }

      subject.pause!
    end
  end

  describe '#resume!' do
    before { subject.start! }
    before { subject.pause! }

    it 'calls Log[:ai].debug' do
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Resuming: #{subject.inspect}") }
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Resumed: #{subject.inspect}") }

      subject.resume!
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
