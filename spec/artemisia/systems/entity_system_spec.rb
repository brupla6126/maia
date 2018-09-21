require 'artemisia/systems/entity_system'

RSpec.describe Artemisia::Systems::EntitySystem do
  let(:system) { described_class.new(attributes) }

  let(:attributes) { OpenStruct.new(aspect: aspect, active: active) }
  let(:active) { true }
  let(:aspect) { double('[aspect]') }

  subject { system }

  describe '#initialize' do
    it 'sets variables' do
      expect(subject.type).to eq(:entity_system)
      expect(subject.active).to be_truthy
      expect(subject.aspect).to eq(aspect)
    end
  end
end
