require 'araignee/ai/core/guard'
require 'araignee/ai/core/failer'
require 'araignee/ai/core/interrogator'
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
  describe '#process' do
    subject { guard.process(entity, world) }

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

    context 'when interrogator returns :succeeded' do
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
