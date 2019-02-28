require 'araignee/ai/core/interrogator'
require 'spec_helpers/ai_helpers'

RSpec.describe Araignee::Ai::Core::Interrogator do
  include Araignee::Ai::Helpers

  let(:child) { Araignee::Ai::Helpers::NodeSucceeded.new }
  let(:interrogator) { described_class.new(child: child) }

  before do
    child.state = initial_state
    interrogator.state = initial_state
  end

  subject { interrogator }

  describe '#process' do
    let(:request) { OpenStruct.new }

    subject { super().process(request) }

    context 'when child interrogator returns :succeeded' do
      it 'has succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when child interrogator returns :failed' do
      let(:child) { Araignee::Ai::Helpers::NodeFailed.new }

      it 'has failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when child interrogator returns neither :failed nor :succeeded' do
      let(:child) { Araignee::Ai::Helpers::NodeBusy.new }

      it 'has failed' do
        expect(subject.failed?).to eq(true)
      end
    end
  end
end
