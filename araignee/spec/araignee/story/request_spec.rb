require 'araignee/story/request'

RSpec.describe Araignee::Story::Request do
  class MyRequest < described_class
    def allowed
      %i[a b]
    end

    def defaults
      { b: 22 }
    end
  end

  let(:params) { { a: 1, b: 2 } }
  let(:request) { described_class.new(params) }

  subject { request }

  describe '#initialize' do
    context 'without default params' do
      it 'params are set as passed in' do
        expect(subject.a).to eq(1)
        expect(subject.b).to eq(2)
      end
    end

    context 'with default params' do
      let(:params) { { a: 1 } }
      let(:request) { MyRequest.new(params) }

      it 'missing params are set with default values' do
        expect(subject.a).to eq(1)
        expect(subject.b).to eq(22)
      end
    end
  end

  describe '#valid?' do
    subject { super().valid? }

    context 'with unallowed params' do
      it 'raises ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, 'unallowed params: a, b')
      end
    end

    context 'with allowed params' do
      let(:params) { { a: 1, b: 2 } }
      let(:request) { MyRequest.new(params) }

      it 'is valid' do
        expect(subject).to be_truthy
      end
    end
  end
end
