require 'araignee/utils/state'

RSpec.describe Araignee::Utils::State do
  subject { state }

  before { allow(Araignee::Utils::Log).to receive(log_level) }
  before { allow(state).to receive(:inspect) { 'abc' } }

  after { subject }

  let(:state) { described_class.new(context) }

  let(:context) { double('[context]') }

  let(:log_level) { :info }

  describe '#initialize' do
    it 'context is set' do
      expect(state.context).to eq(context)
    end
  end

  describe '#enter' do
    subject { super().enter }

    it 'calls Log::info' do
      expect(state).to receive(:inspect)

      expect(Araignee::Utils::Log).to receive(log_level) do |&block|
        expect(block.call).to eq("Entering state #{state.inspect}")
      end
    end
  end

  describe '#leave' do
    subject { super().leave }

    it 'calls Log::info' do
      expect(state).to receive(:inspect)

      expect(Araignee::Utils::Log).to receive(log_level) do |&block|
        expect(block.call).to eq("Leaving state #{state.inspect}")
      end
    end
  end

  describe '#pause' do
    subject { super().pause }

    it 'calls Log::info' do
      expect(state).to receive(:inspect)

      expect(Araignee::Utils::Log).to receive(log_level) do |&block|
        expect(block.call).to eq("Pausing state #{state.inspect}")
      end
    end
  end

  describe '#resume' do
    subject { super().resume }

    it 'calls Log::info' do
      expect(state).to receive(:inspect)

      expect(Araignee::Utils::Log).to receive(log_level) do |&block|
        expect(block.call).to eq("Resuming state #{state.inspect}")
      end
    end
  end
end
