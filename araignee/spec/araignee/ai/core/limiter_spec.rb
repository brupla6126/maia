require 'araignee/ai/core/fabricators/ai_node_fabricator'
require 'araignee/ai/core/fabricators/ai_limiter_fabricator'

RSpec.describe Ai::Core::Limiter do
  let(:world) { {} }
  let(:entity) { {} }

  let(:limit) { 1 }
  let(:limiter) { Fabricate(:ai_limiter, child: child, limit: limit) }

  let(:node_success) { Fabricate(:ai_node_succeeded) }
  let(:node_failure) { Fabricate(:ai_node_failed) }
  let(:node_busy) { Fabricate(:ai_node_busy) }

  let(:child) { node_success }

  subject { limiter }

  describe '#initialize' do
    context 'when limit is not set' do
      let(:limiter) { Fabricate(:ai_limiter, child: child) }

      it 'limit set to default value' do
        expect(subject.limit).to eq(1)
      end
    end

    context 'with Fabrication attributes' do
      let(:node) { Fabricate(:ai_wait, limit: limit) }

      it 'sets limit' do
        expect(subject.limit).to eq(limit)
      end
    end

    context 'with Virtus attributes' do
      let(:node) { Ai::Core::Wait.new(limit: limit) }

      it 'sets limit' do
        expect(subject.limit).to eq(limit)
      end
    end
  end

  describe '#process' do
    subject { super().process(entity, world) }

    before { limiter.start! }

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

    context 'when doing 5 loops of :succeeded and :limit equals to 3' do
      let(:child) { node_busy }

      context 'calling child#process' do
        before { allow(limiter.child).to receive(:process).with(entity, world) { limiter.child } }

        it 'calls child#process 3 times' do
          expect(limiter.child).to receive(:process).with(entity, world).exactly(3).times

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
  end

  describe 'reset_node' do
    subject { limiter.send(:reset_node) }

    context 'calling reset_attribute' do
      before { allow(limiter).to receive(:reset_attribute) }

      it 'calls reset_attribute' do
        expect(limiter).to receive(:reset_attribute).with(:times)
        expect(limiter).to receive(:reset_attribute).with(:response)
        subject
      end
    end

    context '' do
      it 'resets times' do
        expect(limiter.limit).to eq(limit)
        expect(limiter.response).to eq(:unknown)
      end
    end
  end

  describe 'validates attributes' do
    subject { limiter.send(:validate_attributes) }

    context 'invalid child' do
      let(:child) { nil }

      it 'raises ArgumentError, invalid decorating child' do
        expect { subject }.to raise_error(ArgumentError, 'invalid decorating child')
      end
    end

    context 'invalid limit' do
      let(:limit) { 0 }
      let(:limiter) { Fabricate(:ai_limiter, child: child, limit: limit) }

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

  describe 'handle_response' do
    subject { limiter.send(:handle_response, response) }

    context 'busy' do
      let(:response) { :busy }

      it 'returns :busy' do
        expect(subject).to eq(:busy)
      end
    end

    context 'failed' do
      let(:response) { :failed }

      it 'returns :failed' do
        expect(subject).to eq(:failed)
      end
    end

    context 'unknown' do
      let(:response) { :unknown }

      it 'returns :succeeded' do
        expect(subject).to eq(:succeeded)
      end
    end
  end
end
