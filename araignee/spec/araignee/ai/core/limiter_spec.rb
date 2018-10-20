require 'araignee/ai/core/limiter'

RSpec.describe Araignee::Ai::Core::Limiter do
  let(:world) { {} }
  let(:entity) { {} }

  let(:limit) { 5 }
  let(:limiter) { described_class.new(child: child, limit: limit) }

  let(:node_busy) { Araignee::Ai::Core::NodeBusy.new }
  let(:node_failed) { Araignee::Ai::Core::NodeFailed.new }
  let(:node_succeeded) { Araignee::Ai::Core::NodeSucceeded.new }

  let(:child) { node_succeeded }

  subject { limiter }

  describe '#initialize' do
    context 'when limit is not set' do
      let(:limiter) { described_class.new(child: child) }

      it 'limit set to default value' do
        expect(subject.limit).to eq(1)
      end
    end

    context 'with limit set' do
      let(:limit) { 2 }

      it 'sets limit' do
        expect(subject.limit).to eq(limit)
      end
    end

    context 'with attributes' do
      let(:node) { Araignee::Ai::Core::Wait.new(limit: limit) }

      it 'sets limit' do
        expect(subject.limit).to eq(limit)
      end
    end
  end

  describe '#process' do
    subject { super().process(entity, world) }

    let(:limit) { 3 }

    context 'calling limiter#handle_response' do
      before { allow(limiter).to receive(:handle_response) { :succeeded } }
      before { allow(limiter.child).to receive(:response) { :succeeded } }

      it 'has called limiter#process' do
        expect(limiter).to receive(:handle_response)
        expect(limiter.child).to receive(:response)
        subject
      end
    end

    context 'when doing 5 loops of :busy and :limit equals to 3' do
      let(:child) { node_busy }

      context 'calling child#process' do
        it 'calls child#process 3 times' do
          1.upto(5) do
            limiter.process(entity, world)
          end

          expect(limiter.failed?).to eq(true)
        end
      end
    end

    context 'when doing 2 loops of :succeeded and :times equals to 3' do
      it 'has succeeded' do
        1.upto(2) do
          limiter.process(entity, world)
          break if limiter.succeeded? || limiter.failed?
        end

        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'child response handling' do
      let(:response) { nil }

      before { allow(child).to receive(:response) { response } }

      context 'busy' do
        let(:response) { :busy }

        it 'returns :busy' do
          expect(subject.response).to eq(:busy)
        end
      end

      context 'failed' do
        let(:response) { :failed }

        it 'returns :failed' do
          expect(subject.response).to eq(:failed)
        end
      end

      context 'unknown' do
        let(:response) { :unknown }

        it 'returns :succeeded' do
          expect(subject.response).to eq(:succeeded)
        end
      end
    end

    context 'invalid limit' do
      let(:limit) { 0 }
      let(:limiter) { described_class.new(child: child, limit: limit) }

      it 'raises ArgumentError, limit must be > 0' do
        expect { subject }.to raise_error(ArgumentError, 'limit must be > 0')
      end
    end

    context 'valid limit' do
      let(:limit) { 3 }

      it 'does not raise ArgumentError' do
        expect { subject }.not_to raise_error
      end
    end
  end

  describe 'reset' do
    subject { super().reset }

    before do
      limiter.times = 1000
      limiter.response = :busy
    end

    it 'resets attributes' do
      expect(subject.times).to eq(0)
      expect(subject.response).to eq(:unknown)
    end
  end
end
