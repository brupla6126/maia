require 'artemisia/system'

RSpec.describe Artemisia::System do
  let(:system) { described_class.new(attributes) }

  let(:attributes) { OpenStruct.new(type: type, aspect: aspect, active: active) }
  let(:type) { nil }
  let(:aspect) { nil }
  let(:active) { true }

  subject { system }

  describe '#initialize' do
    context 'without a type' do
      let(:aspect) { Artemisia::Aspect.new }

      it 'raise ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, 'missing type')
      end
    end

    context 'without an aspect' do
      let(:type) { :entity_system }

      it 'raise ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, 'missing aspect')
      end
    end

    context 'with type and aspect' do
      let(:type) { :entity_system }
      let(:aspect) { Artemisia::Aspect.new }

      it 'has a type' do
        expect(subject.type).to eq(type)
      end

      it 'has an aspect' do
        expect(subject.aspect).to eq(aspect)
      end
    end
  end

  describe '#activate' do
    subject { super().activate }

    let(:type) { :entity_system }
    let(:aspect) { double('[aspect]') }

    context 'was deactivated' do
      let(:active) { false }

      it 'activates' do
        subject
        expect(system.active).to be_truthy
      end
    end
  end

  describe '#deactivate' do
    subject { super().deactivate }

    let(:type) { :entity_system }
    let(:aspect) { double('[aspect]') }

    context 'was activated' do
      let(:active) { true }

      it 'deactivates' do
        subject
        expect(system.active).to be_falsey
      end
    end
  end

  describe '#dummy?' do
    subject { super().dummy? }

    let(:type) { :entity_system }

    context 'without empty aspect' do
      let(:aspect) { double('[aspect]', empty?: false) }

      it 'returns false' do
        expect(subject).to be_falsey
      end
    end

    context 'with empty aspect' do
      let(:aspect) { double('[aspect]', empty?: true) }

      it 'returns true' do
        expect(subject).to be_truthy
      end
    end
  end
end
