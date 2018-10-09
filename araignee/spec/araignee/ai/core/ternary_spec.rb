require 'araignee/ai/core/node'
require 'araignee/ai/core/interrogator'
require 'araignee/ai/core/ternary'

RSpec.describe Ai::Core::Ternary do
  let(:world) { {} }
  let(:entity) { {} }

  let(:child) { Ai::Core::Node.new }
  let(:interrogator) { Ai::Core::Interrogator.new(child: child) }
  let(:yes) { Ai::Core::Node.new }
  let(:no) { Ai::Core::Node.new  }

  let(:ternary) { described_class.new(interrogator: interrogator, yes: yes, no: no) }

  subject { ternary }

  before { allow(child).to receive(:process) { child } }
  before { allow(yes).to receive(:response) { :succeeded } }
  before { allow(yes).to receive(:process) { yes } }
  before { allow(no).to receive(:process) { no } }
  before { allow(no).to receive(:response) { :failed } }

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

  describe '#node_starting' do
    subject { super().start! }

    context 'starting interrogator, yes and no nodes' do
      before { subject }

      it 'interrogator, yes and no nodes running' do
        expect(interrogator.running?).to eq(true)
        expect(interrogator.response).to eq(:unknown)
        expect(yes.running?).to eq(true)
        expect(yes.response).to eq(:succeeded)
        expect(no.running?).to eq(true)
        expect(no.response).to eq(:failed)
      end
    end

    context 'calling validate_attributes' do
      before { allow(ternary).to receive(:validate_attributes) }

      it 'calls validate_attributes' do
        expect(ternary).to receive(:validate_attributes)
        subject
      end
    end
  end

  describe '#node_stopping' do
    subject { super().stop! }

    before { ternary.start! }

    context 'stopping interrogator, yes and no nodes' do
      before { subject }

      it 'interrogator, yes and no nodes running' do
        expect(interrogator.stopped?).to eq(true)
        expect(interrogator.response).to eq(:unknown)
        expect(yes.stopped?).to eq(true)
        expect(yes.response).to eq(:succeeded)
        expect(no.stopped?).to eq(true)
        expect(no.response).to eq(:failed)
      end
    end
  end

  describe '#stop!' do
    subject { ternary.stop! }

    before { ternary.start! }

    it 'ternary should be stopped' do
      subject
      expect(ternary.stopped?).to eq(true)
    end

    it 'interrogator, yes, no should be stopped' do
      subject
      expect(interrogator.stopped?).to eq(true)
      expect(yes.stopped?).to eq(true)
      expect(no.stopped?).to eq(true)
    end
  end

  describe '#process' do
    subject { ternary.process(entity, world) }

    before { ternary.start! }

    context 'when child interrogator returns :succeeded' do
      after { subject }

      before { allow(interrogator).to receive(:response) { :succeeded } }

      it 'calls yes#process' do
        expect(ternary.yes).to receive(:process).with(entity, world)
      end

      it 'ternary has succeeded' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when interrogator returns :failed' do
      after { subject }
      before { allow(interrogator).to receive(:response) { :failed } }

      it 'has called no#process' do
        expect(ternary.no).to receive(:process).with(entity, world)
      end

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
