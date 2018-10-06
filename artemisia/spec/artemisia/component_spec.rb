require 'artemisia/component'

RSpec.describe Artemisia::Component do
  let(:component) { described_class.new(attributes) }
  let(:attributes) { { type: 'position', a: 1, b: 2 } }

  subject { component }

  describe '#initialize' do
    context 'attributes does not contains a type' do
      let(:attributes) { { a: 1, b: 2 } }

      it 'raise ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, 'missing type attribute')
      end
    end

    context 'attributes contains a type' do
      it 'has a type' do
        subject
        expect(component.type).to eq(attributes[:type])
      end
    end
  end

  it 'has attributes' do
    subject
    expect(component.a).to eq(attributes[:a])
    expect(component.b).to eq(attributes[:b])
  end
end
