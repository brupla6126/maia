require 'araignee/ai/core/interrogator'

RSpec.describe Araignee::Ai::Core::Interrogator do
  let(:child) { Araignee::Ai::Core::NodeSucceeded.new }
  let(:interrogator) { described_class.new(child: child) }

  before do
    child.state = initial_state
    interrogator.state = initial_state
  end

  subject { interrogator }

  describe '#process' do
    let(:world) { {} }
    let(:entity) { {} }

    subject { super().process(entity, world) }

    context 'when child interrogator returns :succeeded' do
      it 'has succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when child interrogator returns :failed' do
      let(:child) { Araignee::Ai::Core::NodeFailed.new }

      it 'has failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when child interrogator returns neither :failed nor :succeeded' do
      let(:child) { Araignee::Ai::Core::NodeBusy.new }

      it 'has failed' do
        expect(subject.failed?).to eq(true)
      end
    end
  end
end
