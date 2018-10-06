require 'araignee/ai/core/fabricators/ai_interrogator_fabricator'

RSpec.describe Ai::Core::Interrogator do
  let(:world) { {} }
  let(:entity) { {} }

  let(:interrogator) { Fabricate(:ai_interrogator_succeeded) }

  subject { interrogator }

  describe '#process' do
    subject { super().process(entity, world) }

    before { interrogator.start! }

    context 'when processing interrogator' do
      before { allow(interrogator.child).to receive(:process) { interrogator.child } }

      it 'has called child#process' do
        expect(interrogator.child).to receive(:process).with(entity, world)
        subject
      end
    end

    context 'when child interrogator returns :succeeded' do
      it 'has succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when child interrogator returns :running' do
      let(:interrogator) { Fabricate(:ai_interrogator, child: Fabricate(:ai_node_busy)) }

      it 'has failed' do
        expect(subject.failed?).to eq(true)
      end
    end
  end
end
