require 'timecop'
require 'araignee/ai/core/timeout'

RSpec.describe Ai::Core::Timeout do
  let(:world) { {} }
  let(:entity) { {} }

  let(:delay) { 3 }
  let(:timeout) { described_class.new(delay: delay) }

  subject { timeout }

  describe '#initialize' do
    let(:delay) { 5 }

    it 'is ready' do
      expect(subject.ready?).to eq(true)
    end

    it 'response is :unknown' do
      expect(subject.response).to eq(:unknown)
    end

    context 'with Fabrication attributes' do
      let(:node) { described_class.new(delay: delay) }

      it 'sets identifier' do
        expect(subject.delay).to eq(delay)
      end
    end

    context 'with attributes' do
      let(:node) { described_class.new(delay: delay) }

      it 'sets delay' do
        expect(subject.delay).to eq(delay)
      end
    end
  end

  describe '#process' do
    subject { super().process(entity, world) }

    before { timeout.start! }

    context 'when delay of 3 seconds' do
      after { Timecop.return }

      context 'before timeout expires' do
        it 'is running' do
          Timecop.travel(Time.now + 1)

          expect(subject.running?).to eq(true)
        end
      end

      context 'after timeout expires' do
        it 'has failed' do
          Timecop.travel(Time.now + 5)

          expect(subject.failed?).to eq(true)
        end
      end
    end
  end

  describe '#reset_node' do
    subject { timeout.send(:reset_node) }

    context 'reset_attribute' do
      before { allow(timeout).to receive(:reset_attribute) }

      it 'calls reset_attribute' do
        expect(timeout).to receive(:reset_attribute).with(:start_time)
        expect(timeout).to receive(:reset_attribute).with(:response)
        subject
      end
    end

    context '' do
      let(:now) { Time.local(2017, 5, 12) }

      before { Timecop.freeze(now) }
      after { Timecop.return }

      it 'start_time is set to Time.now' do
        expect(timeout.start_time).to eq(now)
        expect(timeout.response).to eq(:unknown)
        subject
      end
    end
  end

  context 'validates attributes' do
    subject { timeout.send(:validate_attributes) }

    context 'invalid identifier' do
      let(:identifier) { Ai::Core::Node.new }
      let(:timeout) { described_class.new(identifier: identifier, delay: delay) }

      it 'raises ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, 'invalid identifier')
      end
    end

    context 'invalid delay' do
      let(:delay) { 0 }

      it 'raises ArgumentError delay must be > 0' do
        expect { subject }.to raise_error(ArgumentError, 'delay must be > 0')
      end
    end

    context 'valid delay' do
      let(:delay) { 3 }

      it 'does not raise ArgumentError' do
        expect { subject }.not_to raise_error
      end
    end
  end
end
