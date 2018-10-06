require 'artemisia/managers/tag_manager'

RSpec.describe Artemisia::Managers::TagManager do
  let(:manager) { described_class.new(attributes) }

  let(:attributes) { OpenStruct.new }

  let(:tag) { 'boss' }
  let(:entity) { { boss: :big } }

  subject { manager }

  describe '#initialize' do
    it 'set its type to :tag_manager' do
      expect(subject.type).to eq(:tag_manager)
    end

    it 'does not have tags' do
      expect(subject.tags.empty?).to be_truthy
    end
  end

  describe '#add' do
    subject { super().add(tag, entity) }

    it 'tags the entity' do
      subject
      expect(manager.tags.count).to eq(1)
      expect(manager.tags).to include(tag)
    end

    it 'emits the :tag_added event' do
      expect(manager).to receive(:emit).with(:tag_added, tag, entity)
      subject
    end

    it 'return itself' do
      expect(subject).to eq(manager)
    end
  end

  describe '#remove' do
    subject { super().remove(tag) }

    before { manager.add(tag, entity) }

    it 'removes the tag' do
      expect(manager.tags.count).to eq(1)

      subject

      expect(manager.tags.count).to eq(0)
    end

    it 'emits the :tag_removed event' do
      expect(manager).to receive(:emit).with(:tag_removed, tag, entity)
      subject
    end

    it 'return itself' do
      expect(subject).to eq(manager)
    end
  end

  describe '#has?' do
    subject { super().has?(tag) }

    context 'known tag' do
      before { manager.add(tag, entity) }

      it 'returns true' do
        expect(subject).to be_truthy
      end
    end

    context 'unknown tag' do
      let(:tag) { 'unknown' }

      it 'returns false' do
        expect(subject).to be_falsey
      end
    end
  end

  describe '#entity' do
    subject { super().entity(tag) }

    context 'known tag' do
      before { manager.add(tag, entity) }

      it 'returns the entity' do
        expect(subject).to eq(entity)
      end
    end

    context 'unknown tag' do
      let(:tag) { 'unknown' }

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end
  end
end
