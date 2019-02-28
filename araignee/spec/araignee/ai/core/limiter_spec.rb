require 'araignee/ai/core/limiter'

RSpec.describe Araignee::Ai::Core::Limiter do
  include Araignee::Ai::Helpers

  let(:limit) { 5 }
  let(:limiter) { described_class.new(child: child) }

  let(:node_busy) { Araignee::Ai::Helpers::NodeBusy.new }
  let(:node_failed) { Araignee::Ai::Helpers::NodeFailed.new }
  let(:node_succeeded) { Araignee::Ai::Helpers::NodeSucceeded.new }

  let(:child) { node_succeeded }

  before do
    limiter.state = initial_state(limit: limit, times: 0)
    node_busy.state = initial_state
    node_failed.state = initial_state
    node_succeeded.state = initial_state
  end

  subject { limiter }

  describe '#process' do
    let(:request) { OpenStruct.new }
    let(:limit) { 3 }

    subject { super().process(request) }

    context 'when doing 5 loops of :busy and :limit equals to 3' do
      it 'calls child#process 5 times' do
        1.upto(5) do
          limiter.process(request)
        end

        expect(limiter.failed?).to eq(true)
      end
    end

    context 'when doing 2 loops of :succeeded and :times equals to 3' do
      context 'child responding :succeeded' do
        it 'has succeeded' do
          expect(subject.succeeded?).to eq(true)
        end
      end

      context 'child responding :failed' do
        let(:child) { node_failed }

        it 'has failed' do
          expect(subject.failed?).to eq(true)
        end
      end

      context 'child responding :busy' do
        let(:child) { node_busy }

        it 'is busy' do
          expect(subject.busy?).to eq(true)
        end
      end
    end

    context 'invalid limit' do
      let(:limit) { 0 }

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
      limiter.state.times = 1000
    end

    it 'resets attributes' do
      expect(subject.state.times).to eq(0)
    end
  end
end
