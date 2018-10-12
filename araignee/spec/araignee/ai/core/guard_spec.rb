require 'araignee/ai/core/guard'
require 'araignee/ai/core/failer'
require 'araignee/ai/core/interrogator'
require 'araignee/ai/core/node'
require 'araignee/ai/core/succeeder'

RSpec.describe Ai::Core::Guard do
  let(:world) { {} }
  let(:entity) { {} }

  let(:interrogator_succeeded) { Ai::Core::InterrogatorSucceeded.new }
  let(:interrogator_failed) { Ai::Core::InterrogatorFAiled.new }
  let(:interrogator) { interrogator_succeeded }
  let(:guarded) { Ai::Core::Node.new }

  let(:guard) { described_class.new(interrogator: interrogator, child: guarded) }

  subject { guard }

  describe '#initialize' do
    it 'sets interrogator' do
      expect(subject.interrogator).to eq(interrogator_succeeded)
    end

    it 'sets guarded' do
      expect(subject.child).to eq(guarded)
    end
  end

  describe '#node_starting' do
    subject { super().start! }

    context 'starting interrogator and child' do
      before { subject }

      it 'interrogator and child are running' do
        expect(interrogator.running?).to eq(true)
        expect(guarded.running?).to eq(true)
      end
    end

    context 'validates attributes' do
      context 'invalid interrogator node' do
        let(:interrogator) { nil }

        it 'raises ArgumentError' do
          expect { subject }.to raise_error(ArgumentError, 'interrogator node nil')
        end
      end

      context 'invalid guarded node' do
        let(:guarded) { nil }

        it 'raises ArgumentError' do
          expect { subject }.to raise_error(ArgumentError, 'invalid decorated child')
        end
      end
    end
  end

  describe '#node_stopping' do
    before { guard.start! }

    subject { super().stop! }

    before { subject }

    context 'stopping interrogator and child' do
      it 'interrogator and child are stopped' do
        expect(interrogator.stopped?).to eq(true)
        expect(guarded.stopped?).to eq(true)
      end
    end
  end

  describe '#process' do
    subject { guard.process(entity, world) }

    before { guard.start! }

    context 'calling guard#handle_response' do
      before { allow(guard).to receive(:handle_response) { :succeeded } }

      it 'has called guard#process' do
        expect(guard).to receive(:handle_response)
        subject
      end
    end

    context 'when processing guard' do
      before { allow(guard.child).to receive(:process) { guard.child } }

      it 'has called child#process' do
        expect(guard.child).to receive(:process).with(entity, world)
        subject
      end
    end

    context 'when child interrogator returns :succeeded' do
      let(:interrogator) { Ai::Core::Interrogator.new(child: Ai::Core::NodeSucceeded.new) }

      context 'calling interrogator#process' do
        before { allow(guard.interrogator).to receive(:process) { guard.child } }

        it 'has called interrogator#process' do
          expect(guard.interrogator).to receive(:process).with(entity, world)
          subject
        end
      end

      context 'when guarded returns :succeeded' do
        let(:guarded) { Ai::Core::NodeSucceeded.new }

        it 'has succeeded' do
          expect(subject.succeeded?).to eq(true)
        end
      end

      context 'when guarded returns :failed' do
        let(:guarded) { Ai::Core::NodeFailed.new }

        it 'has failed' do
          expect(subject.failed?).to eq(true)
        end
      end
    end

    context 'when child interrogator returns :busy' do
      let(:interrogator) { Ai::Core::Interrogator.new(child: Ai::Core::NodeBusy.new) }

      it 'has failed' do
        expect(subject.failed?).to eq(true)
      end
    end
  end
end
