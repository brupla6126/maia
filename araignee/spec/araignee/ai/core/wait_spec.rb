require 'timecop'
require 'araignee/ai/core/wait'

RSpec.describe Araignee::Ai::Core::Wait do
  let(:world) { {} }
  let(:entity) { {} }

  let(:delay) { 3 }
  let(:wait) { described_class.new(delay: delay) }

  subject { wait }

  describe '#initialize' do
    it 'response is :unknown' do
      expect(subject.response).to eq(:unknown)
    end

    context 'with attributes' do
      let(:node) { described_class(delay: delay) }

      it 'sets delay' do
        expect(subject.delay).to eq(delay)
      end
    end
  end

  describe '#process' do
    subject { super().process(entity, world) }

    context 'when wait of 3 seconds' do
      after { Timecop.return }

      context 'before wait expires' do
        it 'is busy' do
          wait

          Timecop.travel(Time.now + 1)

          expect(subject.busy?).to eq(true)
        end
      end

      context 'after wait expires' do
        it 'has succeeded' do
          wait

          Timecop.travel(Time.now + 5)

          expect(subject.succeeded?).to eq(true)
        end
      end
    end
  end

  describe 'reset' do
    subject { super().reset }

    context 'reset_attribute' do
      it 'calls reset_attribute' do
        expect(wait.response).to eq(:unknown)
        subject
      end
    end

    context '' do
      let(:now) { Time.local(2017, 5, 12) }

      before { Timecop.freeze(now) }
      after { Timecop.return }

      it 'start_time is set to Time.now' do
        expect(wait.start_time).to eq(now)
        subject
      end
    end
  end

  context 'validates attributes' do
    subject { wait.send(:validate_attributes) }

    context 'invalid identifier' do
      let(:identifier) { Araignee::Ai::Core::Node.new }
      let(:wait) { described_class.new(identifier: identifier, delay: delay) }

      it 'raises ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, 'invalid identifier')
      end
    end

    context 'invalid delay' do
      let(:delay) { 0 }

      it 'should raise ArgumentError delay must be > 0' do
        expect { subject }.to raise_error(ArgumentError, 'delay must be > 0')
      end
    end

    context 'valid delay' do
      let(:delay) { 3 }

      it 'does not raise ArgumentError delay must be > 0' do
        expect { subject }.not_to raise_error
      end
    end
  end
end
