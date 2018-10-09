require 'araignee/ai/core/node'
require 'araignee/ai/core/stopper'

RSpec.describe Ai::Core::Stopper do
  let(:world) { {} }
  let(:entity) { {} }

  let(:node_succeeded) { Ai::Core::Node.new }
  let(:child) { node_succeeded }
  let(:stopper) { described_class.new(child: child) }

  subject { stopper }

  before { allow(node_succeeded).to receive(:response) { :succeeded } }

  describe '#initialize' do
    it 'is ready' do
      expect(subject.ready?).to eq(true)
    end

    it 'response is :unknown' do
      expect(subject.response).to eq(:unknown)
    end
  end

  describe '#process' do
    subject { super().process(entity, world) }

    before { stopper.start! }

    context 'when stopper processes a child node already running' do
      let(:child) { Ai::Core::Node.new }

      context 'calling child#stop!' do
        before { allow(child).to receive(:stop!) }

        it 'child does receive stop!' do
          expect(child).to receive(:stop!)
          subject
        end
      end

      it 'child node is stopped' do
        expect(subject.child.stopped?).to eq(true)
      end
    end

    context 'when stopper processes a child node that is paused' do
      let(:child) { Ai::Core::Node.new }

      before { child.pause! }

      context 'calling child#stop!' do
        before { allow(child).to receive(:stop!) }

        it 'child does receive stop!' do
          expect(child).to receive(:stop!)
          subject
        end
      end

      it 'child node is stopped' do
        expect(subject.child.stopped?).to eq(true)
      end
    end

    context 'when stopper processes a child node that is stopped' do
      let(:child) { Ai::Core::Node.new }

      before { child.stop! }

      context 'calling child#stop!' do
        before { allow(child).to receive(:stop!) }

        it 'child does not receive stop!' do
          expect(child).not_to receive(:stop!)
          subject
        end
      end

      it 'child node is stopped' do
        expect(subject.child.running?).to eq(false)
      end
    end

    it 'has succeeded' do
      expect(subject.succeeded?).to eq(true)
    end
  end
end
