require 'artemisia/world'

RSpec.describe Artemisia::World do
  let(:world) { described_class.new(id) }
  let(:id) { :new_world }

  subject { world }

  describe '#initialize' do
    it 'has managers and systems' do
      subject
      expect(world.id).to eq(id)
      expect(world.managers).not_to be_nil
      expect(world.systems).not_to be_nil
    end
  end
end
