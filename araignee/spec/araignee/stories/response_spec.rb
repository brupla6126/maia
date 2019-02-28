require 'araignee/stories/response'

RSpec.describe Araignee::Stories::Response do
  let(:errors) { ['error1'] }
  let(:params) { { result: 1, errors: errors } }
  let(:defaults) { { errors: [] } }

  let(:response) { described_class.new(params: params, defaults: defaults) }

  subject { response }

  describe '#initialize' do
    context 'without default params' do
      let(:defaults) { {} }

      it 'params are set as passed in' do
        expect(subject.result).to eq(1)
        expect(subject.errors).to eq(errors)
      end
    end

    context 'with default params' do
      let(:params) { { result: 1 } }

      it 'missing params are set with default values' do
        expect(subject.errors).to eq(defaults[:errors])
      end
    end
  end
end
