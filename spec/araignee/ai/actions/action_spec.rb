require 'araignee/ai/actions/succeeded'

include AI::Actions

RSpec.describe AI::Actions::Action do

  describe '#initialize' do
    subject { ActionSucceeded.new(attributes) }

    context 'with attributes nil' do
      let(:attributes) { nil }

      it 'should raise ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, "attributes must be Hash")
      end
    end

    context 'attributes of invalid type' do
      let(:attributes) { [] }

      it 'should raise ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, "attributes must be Hash")
      end
    end

    context 'with attributes empty' do
      let(:attributes) { {} }

      it 'identifier should not be nil' do
        expect(subject.identifier).to be_a(String)
      end

      it 'state should be ready' do
        expect(subject.ready?).to eq(true)
      end

      it 'elapsed should equal 0' do
        expect(subject.elapsed).to eq(0)
      end

      it 'response should be :unknown' do
        expect(subject.response).to eq(:unknown)
      end

      it 'parent should equal nil' do
        expect(subject.parent).to eq(nil)
      end
    end
  end
end
