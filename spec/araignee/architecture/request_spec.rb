require 'araignee/architecture/request'

RSpec.describe Architecture::Story::Request do
  subject { request }

  let(:request) { described_class.new(params) }
  let(:params) { { a: 1, b: 2 } }

  describe '#initialize' do
    it 'params are set' do
      expect(request.instance_variable_get(:@params)).to eq(params)
    end
  end

  describe '#params' do
    subject { super().params }

    it { expect(subject).to eq({}) }

    context 'with default values' do
      before do
        allow(request).to receive(:defaults) { { c: 3 } }
        allow(request).to receive(:permitted) { %i[a b c] }
      end

      it { expect(subject).to eq(a: 1, b: 2, c: 3) }
    end

    context 'with permitted parameters' do
      before do
        allow(request).to receive(:permitted) { %i[a b c] }
      end

      context 'with extra parameters' do
        let(:params) { { a: 1, b: 2, d: 4 } }

        it { expect(subject).to eq(a: 1, b: 2) }
      end
    end
  end

  describe 'pagination_params' do
    subject { super().pagination_params }

    let(:params) { { current_page: 0, per_page: 20, a: 1 } }

    it { is_expected.to eq({}) }
  end
end
