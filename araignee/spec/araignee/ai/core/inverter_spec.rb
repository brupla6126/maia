require 'araignee/ai/core/inverter'
require 'spec_helpers/ai_helpers'

RSpec.describe Araignee::Ai::Core::Inverter do
  include Araignee::Ai::Helpers

  let(:child) { Araignee::Ai::Helpers::NodeSucceeded.new }
  let(:inverter) { described_class.new(child: child) }

  before do
    child.state = initial_state
    inverter.state = initial_state
  end

  subject { inverter }

  describe '#initialize' do
    it 'sets child' do
      expect(inverter.child).to eq(child)
    end
  end

  describe '#process' do
    let(:request) { OpenStruct.new }

    subject { super().process(request) }

    context 'when inverter processes a node that succeeded' do
      it 'has failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when inverter processes a node that failed' do
      let(:child) { Araignee::Ai::Helpers::NodeFailed.new }

      it 'has not failed' do
        expect(subject.failed?).to eq(false)
      end
    end

    context 'when inverter processes a node that is busy' do
      let(:child) { Araignee::Ai::Helpers::NodeBusy.new }

      it 'is busy' do
        expect(subject.busy?).to eq(true)
      end
    end
  end
end
