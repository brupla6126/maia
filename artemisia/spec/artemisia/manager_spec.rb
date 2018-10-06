require 'artemisia/manager'

RSpec.describe Artemisia::Manager do
  let(:manager) { described_class.new(attributes) }

  let(:attributes) { OpenStruct.new(type: type) }
  let(:type) { nil }

  subject { manager }

  describe '#initialize' do
    context 'without a type' do
      it 'raise ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, 'missing type')
      end
    end

    context 'with a type' do
      let(:type) { :component_manager }

      it 'has a type' do
        expect(subject.type).to eq(type)
      end
    end
  end
end
