require 'araignee/story/response'

RSpec.describe Story::Response do
  class MyResponse < described_class
    def defaults
      { errors: [] }
    end
  end

  let(:errors) { ['error1'] }
  let(:params) { { result: 1, errors: errors } }
  let(:response) { described_class.new(params) }

  subject { response }

  describe '#initialize' do
    context 'without default params' do
      it 'params are set as passed in' do
        expect(subject.result).to eq(1)
        expect(subject.errors).to eq(errors)
      end
    end

    context 'with default params' do
      let(:params) { { result: 1 } }
      let(:response) { MyResponse.new(params) }

      it 'missing params are set with default values' do
        expect(subject.result).to eq(1)
        expect(subject.errors).to eq([])
      end
    end
  end
end
