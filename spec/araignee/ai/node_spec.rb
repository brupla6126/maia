require 'timecop'
require 'araignee/ai/fabricators/ai_node_fabricator'

RSpec.describe AI::Node do
  let(:world) { double('[world]') }
  let(:entity) { {} }

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

  let(:series) { {} }
  let(:recorder) { Recorder.new(series: series) }
  let(:node) { Fabricate(:ai_node) }

  subject { node }

  describe '#initialize' do
    it 'node is ready' do
      expect(node.ready?).to eq(true)
    end

    it 'response is set to :unknown' do
      expect(node.response).to eq(:unknown)
    end

    it 'recorder is set to nil' do
      expect(node.recorder).to eq(nil)
    end

    it 'start_time is set to nil' do
      expect(node.start_time).to eq(nil)
    end

    it 'stop_time is set to nil' do
      expect(node.stop_time).to eq(nil)
    end

    context 'with attributes' do
      let(:identifier) { 'abcdef' }
      let(:node) { Fabricate(:ai_node, identifier: identifier) }

      before { allow_any_instance_of(AI::Node).to receive(:validate_attributes) }
      before { subject }

      it 'identifier is set' do
        expect(node.identifier).to eq(identifier)
      end

      it 'validates attributes' do
        expect(node).to have_received(:validate_attributes)
      end
    end
  end

  describe 'validate_attributes' do
    subject { node.validate_attributes }

    context 'invalid identifier' do
      let(:identifier) { AI::Node.new }
      let(:node) { Fabricate(:ai_node, identifier: identifier) }

      it 'raises ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, "invalid identifier: #{identifier}")
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

      it 'return true' do
        expect(subject).to eq(true)
      end
    end

    context 'when state equals paused' do
      before { node.start! }
      before { node.pause! }

      it 'return true' do
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

    context 'with a recorder' do
      let(:node) { Fabricate(:ai_node, recorder: recorder) }

      before { allow(node).to receive(:start_recording) }
      before { allow(node).to receive(:stop_recording) }

      it 'calls before_execute and after_execute hooks' do
        expect(node).to receive(:start_recording)
        expect(node).to receive(:stop_recording)
        expect(subject.recorder.data[:values]).not_to eq([])
      end
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

    before { allow(node).to receive(:reset_attribute).with(:response) }

    it 'resets response attribute' do
      expect(node).to receive(:reset_attribute).with(:response)
      subject
    end
  end

  describe '#start!' do
    before { subject.start! }

    it 'is running and calls Log[:ai].debug twice' do
      expect(subject.running?).to eq(true)
      expect(Log[:ai]).to have_received(:debug).twice
    end
  end

  describe '#stop!' do
    before { subject.start! }
    before { subject.stop! }

    it 'is stopped and calls Log[:ai].debug twice' do
      expect(node.stopped?).to eq(true)
      expect(Log[:ai]).to have_received(:debug).exactly(4).times
    end
  end

  describe '#pause!' do
    before { subject.start! }
    before { subject.pause! }

    it 'is paused and calls Log[:ai].debug twice' do
      expect(node.paused?).to eq(true)
      expect(Log[:ai]).to have_received(:debug).exactly(4).times
    end
  end

  describe '#resume!' do
    before { subject.start! }
    before { subject.pause! }
    before { subject.resume! }

    it 'is running and calls Log[:ai].debug' do
      expect(node.running?).to eq(true)
      expect(Log[:ai]).to have_received(:debug).exactly(6).times
    end
  end

  describe 'start_recording' do
    before { Timecop.freeze(Time.local(1990)) }

    after { Timecop.return }

    subject! { node.send(:start_recording) }

    it 'returns nil' do
      expect(subject).to eq(nil)
    end

    context 'without recorder' do
      it do
        expect(node.start_time).to eq(nil)
        expect(node.stop_time).to eq(nil)
      end
    end

    context 'with recorder' do
      let(:recorder) { double('[recorder]') }
      let(:node) { Fabricate(:ai_node, recorder: recorder) }

      it do
        expect(node.start_time).to eq(Time.now)
        expect(node.stop_time).to eq(nil)
      end
    end
  end

  describe 'stop_recording' do
    before { node.send(:start_recording) }
    before { Timecop.freeze(Time.now + 2.123456) }
    before { allow(recorder).to receive(:record) }

    after { Timecop.return }

    subject! { node.send(:stop_recording) }

    it 'returns nil' do
      expect(subject).to eq(nil)
    end

    context 'without recorder' do
      it do
        expect(node.start_time).to eq(nil)
        expect(node.stop_time).to eq(nil)
      end
    end

    context 'with recorder' do
      let(:recorder) { double('[recorder]') }
      let(:node) { Fabricate(:ai_node, recorder: recorder) }

      it do
        expect(node.stop_time).to eq(Time.now)

        duration = (node.stop_time - node.start_time).round(4)

        expect(recorder).to have_received(:record).with(:duration, duration)
      end
    end
  end

  describe 'node_starting' do
    it 'calls Log[:ai].debug' do
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq "Starting: #{subject.inspect}" }
      subject.send(:node_starting)
    end

    it 'returns nil' do
      expect(subject.send(:node_starting)).to eq(nil)
    end

    it 'resets node' do
      expect(subject).to receive(:reset_node)
      subject.send(:node_starting)
    end
  end

  describe 'node_started' do
    it 'calls Log[:ai].debug' do
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq("Started: #{subject.inspect}") }
      subject.send(:node_started)
    end
  end

  describe 'node_stopping' do
    it 'calls Log[:ai].debug' do
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq "Stopping: #{subject.inspect}" }
      subject.send(:node_stopping)
    end
  end

  describe 'node_stopped' do
    it 'calls Log[:ai].debug' do
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq "Stopped: #{subject.inspect}" }
      subject.send(:node_stopped)
    end
  end

  describe 'node_pausing' do
    it 'calls Log[:ai].debug' do
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq "Pausing: #{subject.inspect}" }
      subject.send(:node_pausing)
    end
  end

  describe 'node_paused' do
    it 'calls Log[:ai].debug' do
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq "Paused: #{subject.inspect}" }
      subject.send(:node_paused)
    end
  end

  describe 'node_resuming' do
    it 'calls Log[:ai].debug' do
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq "Resuming: #{subject.inspect}" }
      subject.send(:node_resuming)
    end
  end

  describe 'node_resumed' do
    it 'calls Log[:ai].debug' do
      expect(Log[:ai]).to receive(:debug) { |&block| expect(block.call).to eq "Resumed: #{subject.inspect}" }
      subject.send(:node_resumed)
    end
  end

  describe 'update_response' do
    context 'invalid response' do
      it 'calls reset_attribute' do
        expect { subject.send(:update_response, nil) }.to raise_error(ArgumentError, 'invalid response: ')
        expect { subject.send(:update_response, :done) }.to raise_error(ArgumentError, 'invalid response: done')
      end
    end

    context 'valid response' do
      let(:responses) { %i[busy failed succeeded] }

      it 'calls reset_attribute' do
        responses.each do |response|
          expect { subject.send(:update_response, response) }.not_to raise_error
          expect(subject.response).to eq(response)
        end
      end
    end
  end
end
