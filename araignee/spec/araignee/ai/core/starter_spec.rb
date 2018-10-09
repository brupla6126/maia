require 'araignee/ai/core/node'
require 'araignee/ai/core/starter'

RSpec.describe Ai::Core::Starter do
  let(:world) { {} }
  let(:entity) { {} }

  let(:node_succeeded) { Ai::Core::Node.new }
  let(:child) { node_succeeded }
  let(:starter) { described_class.new(child: child) }

  subject { stopper }

  before { allow(node_succeeded).to receive(:response) { :succeeded } }

  subject { starter }

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

    before { starter.start! }

    let(:child) { Ai::Core::Node.new }

    context 'when starter processes a child node already running' do
      context 'calling child#resume!' do
        before { allow(child).to receive(:resume!) }

        it 'child does not receive resume!' do
          expect(subject.child).not_to receive(:resume!)
        end
      end

      context 'calling child#start!' do
        before { allow(child).to receive(:start!) }

        it 'child does not receive start!' do
          expect(subject.child).not_to receive(:start!)
        end
      end

      it 'child node is running' do
        expect(subject.child.running?).to eq(true)
      end
    end

    context 'when starter processes a child node that is paused' do
      before { child.pause! }

      context 'calling child#resume!' do
        #        before { allow(child).to receive(:resume!) }

        it 'child does receive resume!' do
          #          expect(subject.child).to receive(:resume!)
        end
      end

      context 'calling child#start!' do
        before { allow(child).to receive(:start!) }

        it 'child does not receive start!' do
          expect(subject.child).not_to receive(:start!)
        end
      end

      it 'child node is running' do
        expect(subject.child.running?).to eq(true)
      end
    end

    context 'when starter processes a child node that is stopped' do
      before { child.stop! }

      context 'calling child#resume!' do
        before { allow(child).to receive(:resume!) }

        it 'child does not receive resume!' do
          expect(subject.child).not_to receive(:resume!)
        end
      end

      context 'calling child#start!' do
        before { allow(child).to receive(:start!) }

        it 'child does receive start!' do
          expect(child).to receive(:start!)
          subject
        end
      end

      it 'child node is running' do
        expect(subject.child.running?).to eq(true)
      end
    end

    it 'has succeeded' do
      expect(subject.succeeded?).to eq(true)
    end
  end
end
