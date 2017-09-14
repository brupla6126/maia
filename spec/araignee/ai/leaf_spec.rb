require 'araignee/ai/leaf'

RSpec.describe AI::Leaf do
  let(:attributes_empty) { {} }
  let(:attributes) { attributes_empty }
  let(:leaf) { AI::Leaf.new(attributes) }

  subject { leaf }

  describe '#initialize' do
    context 'attributes nil' do
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

    context 'attributes empty' do
      it 'should not raise error' do
        expect { subject }.not_to raise_error
      end
    end

    context 'with attributes' do
      let(:identifier) { 'abcdef' }
      let(:parent) { AI::Node.new({}) }
      let(:elapsed) { 5 }
      let(:attributes) { { identifier: identifier, parent: parent, elapsed: elapsed } }

      it 'should set identifier' do
        expect(subject.identifier).to eq(identifier)
      end

      it 'should set parent' do
        expect(subject.parent).to eq(parent)
      end

      it 'should set elapsed' do
        expect(subject.elapsed).to eq(elapsed)
      end
    end
  end
end
