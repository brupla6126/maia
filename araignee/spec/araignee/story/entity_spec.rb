require 'araignee/story/entity'

RSpec.describe Araignee::Story::Entity do
  subject { entity }

  let!(:entity) { described_class.new(attributes) }

  describe '#initialize' do
    let(:attributes) { { a: 1, b: 2 } }

    it 'sets attributes' do
      expect(subject.a).to eq(attributes[:a])
      expect(subject.b).to eq(attributes[:b])
    end
  end
end
