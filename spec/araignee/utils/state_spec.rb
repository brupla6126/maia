require 'araignee/utils/state'

RSpec.describe State do
  subject { state }

  before { allow(Log).to receive(log_level) }
  before { allow(state).to receive(:inspect) { 'abc' } }

  after { subject }

  let(:state) { described_class.new(context) }

  let(:context) { double('[context]') }

  let(:log_level) { :info }

  describe '#enter' do
    subject { state.enter }

    it 'calls Log::info' do
      expect(state).to receive(:inspect)

      expect(Log).to receive(log_level) do |&block|
        expect(block.call).to eq("Entering state #{state.inspect}")
      end
    end
  end

  describe '#leave' do
    subject { state.leave }

    it 'calls Log::info' do
      expect(state).to receive(:inspect)

      expect(Log).to receive(log_level) do |&block|
        expect(block.call).to eq("Leaving state #{state.inspect}")
      end
    end
  end

  describe '#pause' do
    subject { state.pause }

    it 'calls Log::info' do
      expect(state).to receive(:inspect)

      expect(Log).to receive(log_level) do |&block|
        expect(block.call).to eq("Pausing state #{state.inspect}")
      end
    end
  end

  describe '#resume' do
    subject { state.resume }

    it 'calls Log::info' do
      expect(state).to receive(:inspect)

      expect(Log).to receive(log_level) do |&block|
        expect(block.call).to eq("Resuming state #{state.inspect}")
      end
    end
  end
end
