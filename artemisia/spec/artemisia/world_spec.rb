require 'artemisia/world'

RSpec.describe Artemisia::World do
  let(:id) { :new_world }

  let(:world) { described_class.new(id) }

  subject { world }

  describe '#initialize' do
    it 'has managers and systems' do
      subject
      expect(world.id).to eq(id)
      expect(world.managers).to eq({})
      expect(world.systems).to eq({})
    end
  end
end
