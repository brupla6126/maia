require 'artemisia/managers/group_manager'

RSpec.describe Artemisia::Managers::GroupManager do
  class MyGroupManager < Artemisia::Managers::GroupManager
    attr_accessor :group_entities, :entity_groups
  end

  let(:manager) { MyGroupManager.new(attributes) }

  let(:attributes) { OpenStruct.new }

  let(:vilains) { :vilains }
  let(:evils) { :evils }
  let(:super_macho) { { name: 'super_macho' } }
  let(:nefario) { { name: 'nefario' } }

  subject { manager }

  describe '#initialize' do
    it 'is initialized properly' do
      expect(subject.type).to eq(:group_manager)
      expect(subject.group_entities.empty?).to be_truthy
      expect(subject.entity_groups.empty?).to be_truthy
    end
  end

  describe '#add' do
    subject { super().add(super_macho, vilains) }

    it 'add entity to group' do
      expect(subject.group_entities.count).to eq(1)
      expect(subject.group_entities[vilains]).to include(super_macho)
      expect(subject.entity_groups[super_macho]).to include(vilains)
    end

    it 'emits the :entity_added_to_group event' do
      expect(manager).to receive(:emit).with(:entity_added_to_group, vilains, super_macho)
      subject
    end

    it 'return itself' do
      expect(subject).to eq(manager)
    end
  end

  describe '#remove' do
    subject { super().remove(super_macho, vilains) }

    before do
      (manager.group_entities[vilains] ||= []) << super_macho
      (manager.entity_groups[super_macho] ||= []) << vilains
    end

    it 'removes the the entity from the group' do
      subject

      expect(manager.group_entities[vilains].count).to eq(0)
      expect(manager.entity_groups[super_macho].count).to eq(0)
    end

    it 'emits the :entity_removed_from_group event' do
      expect(manager).to receive(:emit).with(:entity_removed_from_group, vilains, super_macho)
      subject
    end

    it 'return itself' do
      expect(subject).to eq(manager)
    end
  end

  describe '#remove_from_groups' do
    subject { super().remove_from_groups(super_macho) }

    before { manager.add(super_macho, vilains) }
    before { manager.add(super_macho, evils) }

    it 'removes the the entity from the group' do
      subject

      expect(manager.group_entities[vilains]).not_to include(super_macho)
      expect(manager.group_entities[evils]).not_to include(super_macho)
    end

    it 'return itself' do
      expect(subject).to eq(manager)
    end
  end

  describe '#entities' do
    subject { super().entities(group) }

    context 'known group' do
      let(:group) { vilains }

      before { manager.add(super_macho, vilains) }
      before { manager.add(nefario, vilains) }

      it 'returns the group entities' do
        expect(subject).to match([super_macho, nefario])
      end
    end

    context 'unknown group' do
      let(:group) { :unknown }

      it 'returns []' do
        expect(subject).to eq([])
      end
    end
  end

  describe '#groups' do
    subject { super().groups(entity) }

    context 'known group' do
      let(:entity) { super_macho }

      before { manager.add(super_macho, vilains) }
      before { manager.add(super_macho, evils) }

      it 'returns the entity groups' do
        expect(subject).to include(vilains, evils)
      end
    end

    context 'unknown group' do
      let(:entity) { :minions }

      it 'returns []' do
        expect(subject).to eq([])
      end
    end
  end

  describe '#any_group?' do
    subject { super().any_group?(entity) }

    context 'known entity' do
      let(:entity) { super_macho }

      before { manager.add(super_macho, vilains) }

      it 'returns the entity' do
        expect(subject).to eq(true)
      end
    end

    context 'unknown entity' do
      let(:entity) { 'unknown' }

      it 'returns nil' do
        expect(subject).to be_falsey
      end
    end
  end

  describe '#in_group?' do
    subject { super().in_group?(entity, group) }

    let(:group) { vilains }

    context 'known entity' do
      let(:entity) { super_macho }

      before { manager.add(super_macho, vilains) }

      it 'returns the entity' do
        expect(subject).to eq(true)
      end
    end

    context 'unknown entity' do
      let(:entity) { 'unknown' }

      it 'returns nil' do
        expect(subject).to be_falsey
      end
    end
  end
end
