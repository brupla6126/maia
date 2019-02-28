require 'araignee/stories/request'

RSpec.describe Araignee::Stories::Request do
  let(:params) { { a: 1, b: 2 } }
  let(:defaults) { { b: 22 } }
  let(:allowed) { %i[a b] }

  let(:request) { described_class.new(params: params, defaults: defaults, allowed: allowed) }

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

      it 'missing params are set with default values' do
        expect(subject.a).to eq(1)
        expect(subject.b).to eq(22)
      end
    end

    context 'with unallowed params' do
      let(:allowed) { %i[] }

      it 'raises ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, 'unallowed params: a, b')
      end
    end
  end
end
