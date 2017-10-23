require 'araignee/ai/core/fabricators/ai_node_fabricator'
require 'araignee/ai/core/fabricators/ai_interrogator_fabricator'
require 'araignee/ai/core/fabricators/ai_ternary_fabricator'

RSpec.describe Ai::Core::Ternary do
  let(:world) { {} }
  let(:entity) { {} }

  let(:interrogator_failed) { Fabricate(:ai_interrogator_failed) }
  let(:interrogator_succeeded) { Fabricate(:ai_interrogator_failed) }

  let(:interrogator) { interrogator_failed }
  let(:yes) { Fabricate(:ai_node_succeeded) }
  let(:no) { Fabricate(:ai_node_failed) }

  let(:ternary) { Fabricate(:ai_ternary, interrogator: interrogator, yes: yes, no: no) }

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
    subject { ternary }

    before { ternary.start! }
    before { ternary.stop! }

    it 'ternary should be stopped' do
      expect(subject.stopped?).to eq(true)
    end

    it 'interrogator, yes, no should be stopped' do
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

      context 'when interrogator returns :succeeded' do
        let(:interrogator) { Fabricate(:ai_node_succeeded) }

        context 'ternary process yes node' do
          before { allow(ternary.yes).to receive(:process) { ternary.yes } }

          it 'has called yes#process' do
            expect(ternary.yes).to receive(:process).with(entity, world)
          end
        end

        context 'ternary returns' do
          it 'has succeeded' do
            expect(subject.succeeded?).to eq(true)
          end
        end
      end

      context 'when interrogator returns :failed' do
        let(:interrogator) { Fabricate(:ai_node_failed) }

        context 'ternary process no node' do
          before { allow(ternary.no).to receive(:process) { ternary.no } }

          it 'has called no#process' do
            expect(ternary.no).to receive(:process).with(entity, world)
          end
        end

        context 'ternary returns' do
          it 'has failed' do
            expect(subject.failed?).to eq(true)
          end
        end
      end
    end

    context 'when interrogator returns unsupported response' do
      let(:interrogator) { Fabricate(:ai_node_succeeded) }
      let(:unsupported_response) { :unsupported }

      before { allow(interrogator).to receive(:response) { unsupported_response } }

      it 'raises ArgumentError invalid response' do
        expect { subject }.to raise_error(ArgumentError, "invalid response: #{unsupported_response}")
      end
    end

    context 'calling handle_response' do
      before { allow(ternary).to receive(:handle_response) { :succeeded } }

      it 'calls handle_response' do
        expect(ternary).to receive(:handle_response)
        subject
      end
    end
  end

  describe 'handle_response' do
    subject { super().send(:handle_response, response) }

    context 'busy' do
      let(:response) { :busy }

      it 'returns :busy' do
        expect(subject).to eq(:busy)
      end
    end

    context 'failed' do
      let(:response) { :failed }

      it 'returns :failed' do
        expect(subject).to eq(:failed)
      end
    end

    context 'succeeded' do
      let(:response) { :succeeded }

      it 'returns :succeeded' do
        expect(subject).to eq(:succeeded)
      end
    end

    context 'unknown' do
      let(:response) { :unknown }

      it 'returns :succeeded' do
        expect(subject).to eq(:succeeded)
      end
    end
  end

  describe 'validates attributes' do
    subject { ternary.send(:validate_attributes) }

    context 'invalid identifier' do
      let(:identifier) { Fabricate(:ai_node) }
      let(:ternary) { Fabricate(:ai_ternary, identifier: identifier, interrogator: interrogator, yes: yes, no: no) }

      it 'raises ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, 'invalid identifier')
      end
    end

    context 'invalid interrogator node' do
      let(:interrogator) { nil }

      it 'raises ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, 'interrogator node nil')
      end
    end

    context 'invalid yes node' do
      let(:yes) { nil }

      it 'raises ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, 'yes node nil')
      end
    end

    context 'invalid no node' do
      let(:no) { nil }

      it 'raises ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, 'no node nil')
      end
    end
  end
end
