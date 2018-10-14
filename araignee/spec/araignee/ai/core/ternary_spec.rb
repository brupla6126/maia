require 'araignee/ai/core/interrogator'
require 'araignee/ai/core/ternary'

RSpec.describe Ai::Core::Ternary do
  let(:world) { {} }
  let(:entity) { {} }

  let(:child) { Ai::Core::Node.new }
  let(:interrogator) { Ai::Core::Interrogator.new(child: child) }
  let(:yes) { Ai::Core::NodeSucceeded.new }
  let(:no) { Ai::Core::NodeFailed.new }

  let(:ternary) { described_class.new(interrogator: interrogator, yes: yes, no: no) }

  subject { ternary }

  before { allow(child).to receive(:process) { child } }

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
    subject { ternary.process(entity, world) }

    context 'when child interrogator returns :succeeded' do
      before { allow(interrogator).to receive(:response) { :succeeded } }

      it 'ternary has succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when interrogator returns :failed' do
      before { allow(interrogator).to receive(:response) { :failed } }

      it 'ternary has failed' do
        expect(subject.failed?).to eq(true)
      end
    end

    context 'when interrogator returns unsupported response' do
      let(:unsupported_response) { :unsupported }

      before { allow(interrogator).to receive(:response) { unsupported_response } }

      it 'raises ArgumentError invalid response' do
        expect { subject }.to raise_error(ArgumentError, "invalid response: #{unsupported_response}")
      end
    end
  end
end
