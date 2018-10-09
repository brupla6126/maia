require 'araignee/ai/core/interrogator'

RSpec.describe Ai::Core::Interrogator do
  let(:world) { {} }
  let(:entity) { {} }

  let(:child) { Ai::Core::Node.new }
  let(:interrogator) { described_class.new(child: child) }

  subject { interrogator }

  describe '#process' do
    subject { super().process(entity, world) }

    before { allow(child).to receive(:process) { child } }

    before { interrogator.start! }

    context 'when child interrogator returns :succeeded' do
      before { allow(child).to receive(:response) { :succeeded } }

      it 'has succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when child interrogator returns :failed' do
      before { allow(child).to receive(:response) { :failed } }

      it 'has failed' do
        expect(subject.failed?).to eq(true)
      end
    end
    context 'when child interrogator returns neither :failed nor :succeeded' do
      before { allow(child).to receive(:response) { :running } }

      it 'has failed' do
        expect(subject.failed?).to eq(true)
      end
    end
  end
end
