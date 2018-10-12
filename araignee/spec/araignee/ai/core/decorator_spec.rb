require 'araignee/ai/core/decorator'
require 'araignee/ai/core/node'

RSpec.describe Ai::Core::Decorator do
  let(:decorated) { Ai::Core::Node.new }
  let(:decorator) { described_class.new(child: decorated) }

  subject { decorator }

  describe '#initialize' do
    it 'decorator is ready' do
      expect(subject.ready?).to eq(true)
    end

    it 'child is ready' do
      expect(subject.child.ready?).to eq(true)
    end

    it 'response is :unknown' do
      expect(subject.child.response).to eq(:unknown)
    end
  end

  describe '#node_starting' do
    subject { super().start! }

    context 'with decorated node able to start' do
      it 'decorated is running' do
        subject
        expect(decorated.running?).to eq(true)
      end

      it 'validates attributes' do
        expect(decorated).to receive(:validate_attributes)
        subject
      end
    end

    it 'decorator is running' do
      subject
      expect(decorator.running?).to eq(true)
    end

    context 'without decorated node' do
      let(:decorated) { nil }

      it 'raises ArgumentError' do
        expect { subject.start! }.to raise_error(ArgumentError, 'invalid decorated child')
      end
    end
  end

  describe '#node_stopping' do
    subject { super().stop! }

    context 'with decorated node able to stop' do
      before { decorator.start! }

      it 'does call child#stop!' do
        expect(decorated).to receive(:stop!)
        subject
      end

      it 'decorated node is stopped' do
        subject
        expect(decorated.stopped?).to eq(true)
      end

      it 'decorator node is stopped' do
        subject
        expect(decorator.stopped?).to eq(true)
      end
    end
  end
end
