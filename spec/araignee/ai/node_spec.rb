require 'araignee/ai/node'

RSpec.describe AI::Node do
  let(:world) { double('[world]') }

  before { allow(world).to receive(:delta) { 1 } }

  before { Log[:ai] = double('Log[:ai] stop!') }
  before { allow(Log[:ai]).to receive(:debug) }
  after { Log[:ai] = Log[:default] }

  it { is_expected.to have_states(:ready, :running, :paused, :stopped, on: :state) }

  it { is_expected.to handle_events :start, when: :ready, on: :state }
  it { is_expected.to handle_events :start, when: :stopped, on: :state }
  it { is_expected.to handle_events :stop, when: :paused, on: :state }
  it { is_expected.to handle_events :stop, when: :running, on: :state }
  it { is_expected.to handle_events :pause, when: :running, on: :state }
  it { is_expected.to handle_events :resume, when: :paused, on: :state }

  let(:attributes_empty) { {} }
  let(:attributes) { attributes_empty }
  let(:node) { AI::Node.new(attributes) }

  subject { node }

  describe '#initialize' do
    context 'with attributes nil' do
      let(:attributes) { nil }

      it 'should raise ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, "attributes must be Hash")
      end
    end

    context 'attributes of invalid type' do
      let(:attributes) { [] }

      it 'should raise ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, "attributes must be Hash")
      end
    end

    context 'with attributes empty' do
      it 'identifier should not be nil' do
        expect(node.identifier).to be_a(String)
      end

      it 'state should be ready' do
        expect(node.ready?).to eq(true)
      end

      it 'elapsed should equal 0' do
        expect(node.elapsed).to eq(0)
      end

      it 'response should be :unknown' do
        expect(node.response).to eq(:unknown)
      end

      it 'parent should equal nil' do
        expect(node.parent).to eq(nil)
      end
    end

    context 'with attributes' do
      let(:identifier) { 'abcdef' }
      let(:parent) { AI::Node.new({}) }
      let(:elapsed) { 5 }
      let(:attributes) { { identifier: identifier, parent: parent, elapsed: elapsed } }

      it 'should set identifier' do
        expect(node.identifier).to eq(identifier)
      end

      it 'should set parent' do
        expect(node.parent).to eq(parent)
      end

      it 'should set elapsed' do
        expect(node.elapsed).to eq(elapsed)
      end

      context 'invalid identifier' do
        let(:identifier) { AI::Node.new({}) }

        it 'should raise ArgumentError' do
          expect { node }.to raise_error(ArgumentError, "invalid identifier: #{identifier}")
        end
      end
    end
  end

  describe '' do
    context 'with values set with accessors' do
      it 'values should be set' do
        node.elapsed = 25

        expect(node.elapsed).to eq(25)
      end
    end
  end

  describe '#can_stop?' do
    subject { node.can_stop? }

    context 'when state equals ready' do
      it 'should return false' do
        expect(subject).to eq(false)
      end
    end

    context 'when state equals running' do
      before { node.start! }

      it 'should return true' do
        expect(subject).to eq(true)
      end
    end

    context 'when state equals paused' do
      before { node.start! }
      before { node.pause! }

      it 'should return true' do
        expect(subject).to eq(true)
      end
    end
  end

  describe '#process' do
    let(:entity) { {} }

    context 'when entity parameter is empty' do
      before { subject.start! }
      before { subject.process(entity, world) }

      it 'node @elapsed should be updated' do
        expect(subject.elapsed).to eq(1)
      end
    end

    it 'returns self' do
      expect(subject.process(entity, world)).to eq(node)
    end

    it 'response should be :unknown' do
      expect(subject.response).to eq(:unknown)
    end
  end

  describe 'busy?' do
    before { subject.response = :busy }

    it 'should return true' do
      expect(subject.busy?).to eq(true)
    end
  end

  describe 'failed?' do
    before { subject.response = :failed }

    it 'should return true' do
      expect(subject.failed?).to eq(true)
    end
  end

  describe 'succeeded?' do
    before { subject.response = :succeeded }

    it 'should return true' do
      expect(subject.succeeded?).to eq(true)
    end
  end

  describe 'reset_node' do
    after { subject.send(:reset_node) }

    it 'should call reset_attribute' do
      expect(subject).to receive(:reset_attribute).with(:elapsed)
    end
  end

  describe '#start!' do
    before { subject.start! }

    it 'should be running and call Log[:ai].debug twice' do
      expect(subject.running?).to eq(true)
      expect(Log[:ai]).to have_received(:debug).twice # node_starting, node_started
    end
  end

  describe '#stop!' do
    before { subject.start! }
    before { subject.stop! }

    it 'should be stopped and call Log[:ai].debug twice' do
      expect(node.stopped?).to eq(true)
      expect(Log[:ai]).to have_received(:debug).exactly(4).times
    end
  end

  describe '#pause!' do
    before { subject.start! }
    before { subject.pause! }

    it 'should be paused and call Log[:ai].debug twice' do
      expect(node.paused?).to eq(true)
      expect(Log[:ai]).to have_received(:debug).exactly(4).times
    end
  end

  describe '#resume!' do
    before { subject.start! }
    before { subject.pause! }
    before { subject.resume! }

    it 'should be running and call Log[:ai].debug' do
      expect(node.running?).to eq(true)
      expect(Log[:ai]).to have_received(:debug).exactly(6).times
    end
  end

  describe 'node_starting' do
    it 'should call Log[:ai].debug' do
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq "Starting: #{subject.inspect}" }
      subject.send(:node_starting)
    end

    it 'should return nil' do
      expect(subject.send(:node_starting)).to eq(nil)
    end

    it 'should reset node' do
      subject.elapsed = 5
      subject.send(:node_starting)
      expect(subject.elapsed).to eq(0)
    end
  end

  describe 'node_started' do
    it 'should call Log[:ai].debug' do
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Started: #{subject.inspect}") }
      subject.send(:node_started)
    end
  end

  describe 'node_stopping' do
    it 'should call Log[:ai].debug' do
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq "Stopping: #{subject.inspect}" }
      subject.send(:node_stopping)
    end
  end

  describe 'node_stopped' do
    it 'should call Log[:ai].debug' do
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq "Stopped: #{subject.inspect}" }
      subject.send(:node_stopped)
    end
  end

  describe 'node_pausing' do
    it 'should call Log[:ai].debug' do
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq "Pausing: #{subject.inspect}" }
      subject.send(:node_pausing)
    end
  end

  describe 'node_paused' do
    it 'should call Log[:ai].debug' do
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq "Paused: #{subject.inspect}" }
      subject.send(:node_paused)
    end
  end

  describe 'node_resuming' do
    it 'should call Log[:ai].debug' do
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq "Resuming: #{subject.inspect}" }
      subject.send(:node_resuming)
    end
  end

  describe 'node_resumed' do
    it 'should call Log[:ai].debug' do
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq "Resumed: #{subject.inspect}" }
      subject.send(:node_resumed)
    end
  end

  describe 'update_response' do
    context 'invalid response' do
      it 'should call reset_attribute' do
        expect { subject.send(:update_response, nil) }.to raise_error(ArgumentError, 'invalid response: ')
        expect { subject.send(:update_response, :done) }.to raise_error(ArgumentError, 'invalid response: done')
      end
    end

    context 'valid response' do
      let(:responses) { %i[busy failed succeeded] }

      it 'should call reset_attribute' do
        responses.each do |response|
          expect { subject.send(:update_response, response) }.not_to raise_error
          expect(subject.response).to eq(response)
        end
      end
    end
  end

end
