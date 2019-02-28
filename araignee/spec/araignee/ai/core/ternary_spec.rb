require 'araignee/ai/core/interrogator'
require 'araignee/ai/core/ternary'
require 'spec_helpers/ai_helpers'

RSpec.describe Araignee::Ai::Core::Ternary do
  include Araignee::Ai::Helpers

  let(:child_succeeded) { Araignee::Ai::Helpers::NodeSucceeded.new }
  let(:child_failed) { Araignee::Ai::Helpers::NodeFailed.new }
  let(:child_busy) { Araignee::Ai::Helpers::NodeBusy.new }
  let(:children) { [1, 2, 3] }

  let(:child_interrogator) { Araignee::Ai::Core::Node.new }
  let(:interrogator) { Araignee::Ai::Core::Interrogator.new(child: child_interrogator) }
  let(:yes) { child_succeeded }
  let(:no) { child_failed }

  let(:ternary) { described_class.new(interrogator: interrogator, yes: yes, no: no) }

  before do
    child_succeeded.state = initial_state
    child_failed.state = initial_state
    child_busy.state = initial_state
    child_interrogator.state = initial_state
    interrogator.state = initial_state
    ternary.state = initial_state
  end

  subject { ternary }

  describe '#initialize' do
    it 'sets interrogator node' do
      expect(subject.interrogator).to eq(interrogator)
    end

    it 'sets yes node' do
      expect(subject.yes).to eq(yes)
    end

    it 'sets no node' do
      expect(subject.no).to eq(no)
    end
  end

  describe '#process' do
    let(:request) { OpenStruct.new }

    subject { super().process(request) }

    context 'when child interrogator returns :succeeded' do
      let(:child_interrogator) { child_succeeded }

      it 'ternary has succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when interrogator returns :failed' do
      let(:child_interrogator) { child_failed }

      it 'ternary has failed' do
        expect(subject.failed?).to eq(true)
      end
    end
  end
end
