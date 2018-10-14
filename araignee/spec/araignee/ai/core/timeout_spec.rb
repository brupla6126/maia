require 'timecop'
require 'araignee/ai/core/timeout'

RSpec.describe Araignee::Ai::Core::Timeout do
  let(:world) { {} }
  let(:entity) { {} }

  let(:delay) { 3 }
  let(:timeout) { described_class.new(delay: delay) }

  subject { timeout }

  describe '#initialize' do
    it 'sets delay' do
      expect(subject.delay).to eq(delay)
    end

    it 'response is :unknown' do
      expect(subject.response).to eq(:unknown)
    end
  end

  describe '#process' do
    subject { super().process(entity, world) }

    context 'when delay of 3 seconds' do
      after { Timecop.return }

      context 'before timeout expires' do
        it 'is busy' do
          timeout

          Timecop.travel(Time.now + 1)

          expect(subject.busy?).to eq(true)
        end
      end

      context 'after timeout expires' do
        it 'has failed' do
          timeout

          Timecop.travel(Time.now + 5)

          expect(subject.failed?).to eq(true)
        end
      end
    end
  end

  describe '#reset_node' do
    subject { super().reset_node }

    context '' do
      let(:now) { Time.local(2017, 5, 12) }

      before { Timecop.freeze(now) }
      after { Timecop.return }

      it 'start_time is reset' do
        subject
        expect(timeout.start_time).to eq(now)
        expect(timeout.response).to eq(:unknown)
      end
    end
  end

  context 'validates attributes' do
    subject { timeout.send(:validate_attributes) }

    context 'invalid identifier' do
      let(:identifier) { Araignee::Ai::Core::Node.new }
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
