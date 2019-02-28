require 'araignee/utils/state'

RSpec.describe Araignee::Utils::State do
  subject { state }

  let(:context) { double('[context]') }

  let(:state) { described_class.new(context) }

  describe '#initialize' do
    it 'context is set' do
      expect(state.context).to eq(context)
    end
  end

  describe '#enter' do
    subject { super().enter }

    it 'emits :state_entering event' do
      expect(state).to receive(:emit).with(:state_entering, state)
      subject
    end
  end

  describe '#leave' do
    subject { super().leave }

    it 'emits :state_leaving event' do
      expect(state).to receive(:emit).with(:state_leaving, state)
      subject
    end
  end

  describe '#pause' do
    subject { super().pause }

    it 'emits :state_pausing event' do
      expect(state).to receive(:emit).with(:state_pausing, state)
      subject
    end
  end

  describe '#resume' do
    subject { super().resume }

    it 'emits :state_resuming event' do
      expect(state).to receive(:emit).with(:state_resuming, state)
      subject
    end
  end
end
