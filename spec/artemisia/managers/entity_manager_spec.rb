require 'artemisia/managers/entity_manager'

RSpec.describe Artemisia::Managers::EntityManager do
  class MyEntityManager < Artemisia::Managers::EntityManager
    attr_accessor :disabled, :entities
  end

  let(:manager) { MyEntityManager.new(attributes) }
  let(:attributes) { OpenStruct.new }

  subject { manager }

  describe '#initialize' do
    it 'is initialized properly' do
      expect(subject.type).to eq(:entity_manager)
    end
  end

  describe '#add' do
    subject { super().add(entity_id) }

    let(:entity_id) { 'abc' }

    context 'new entity' do
      before { manager.add('dummy') }

      it 'adds the entity' do
        expect(subject.entities.count).to eq(2)
        expect(subject.entities).to include(entity_id)
        expect(subject.entities).to include('dummy')
      end

      it 'emits the :entity_enabled event' do
        expect(manager).to receive(:emit).with(:entity_added, entity_id)
        subject
      end
    end

    context 'existing entity' do
      before { manager.add(entity_id) }

      it 'does nothing to the entity' do
        expect(subject.entities.count).to eq(1)
      end

      it 'does not emits the :entity_enabled event' do
        expect(manager).not_to receive(:emit).with(:entity_enabled, entity_id)
        subject
      end
    end
  end

  describe '#remove' do
    subject { super().remove(entity_id) }

    let(:entity_id) { 'abc' }

    context 'unknown entity' do
      before { manager.add('dummy') }

      it 'does nothing to the entity' do
        expect(subject.entities.count).to eq(1)
      end

      it 'does not emits the :entity_removed event' do
        expect(manager).not_to receive(:emit).with(:entity_removed, entity_id)
        subject
      end
    end

    context 'existing entity' do
      before { manager.add('dummy') }
      before { manager.add(entity_id) }

      it 'adds the entity' do
        expect(subject.entities.count).to eq(1)
        expect(subject.entities).not_to include(entity_id)
        expect(subject.entities).to include('dummy')
      end

      it 'emits the :entity_removed event' do
        expect(manager).to receive(:emit).with(:entity_removed, entity_id)
        subject
      end
    end
  end

  describe 'active?' do
    subject { super().active?(entity_id) }

    let(:entity_id) { 'abc' }

    context 'known entity' do
      before { manager.add(entity_id) }

      it 'returns true' do
        expect(subject).to be_truthy
      end
    end

    context 'unknown entity' do
      it 'returns false' do
        expect(subject).to be_falsey
      end
    end
  end

  describe '#enable' do
    subject { super().enable(entity_id) }

    let(:entity_id) { 'abc' }

    context 'active entity' do
      before { manager.disable('dummy') }

      it 'does nothing to the entity' do
        expect(subject.disabled.count).to eq(1)
        expect(subject.disabled).to include('dummy')
        expect(subject.disabled).not_to include(entity_id)
      end

      it 'does not emits the :entity_enabled event' do
        expect(manager).not_to receive(:emit).with(:entity_enabled, entity_id)
        subject
      end
    end

    context 'disabled entity' do
      before { manager.disable(entity_id) }

      it 'enables the entity' do
        expect(subject.disabled.count).to eq(0)
        expect(subject.disabled).not_to include(entity_id)
      end

      it 'emits the :entity_enabled event' do
        expect(manager).to receive(:emit).with(:entity_enabled, entity_id)
        subject
      end
    end
  end

  describe '#disable' do
    subject { super().disable(entity_id) }

    let(:entity_id) { 'abc' }

    context 'active entity' do
      it 'disables the entity' do
        expect(subject.disabled.count).to eq(1)
        expect(subject.disabled).to include(entity_id)
      end

      it 'emits the :entity_enabled event' do
        expect(manager).to receive(:emit).with(:entity_disabled, entity_id)
        subject
      end
    end

    context 'disabled entity' do
      before { manager.disable(entity_id) }

      it 'does nothing to the entity' do
        expect(subject.disabled.count).to eq(1)
        expect(subject.disabled).to include(entity_id)
      end

      it 'does not emits the :entity_enabled event' do
        expect(manager).not_to receive(:emit).with(:entity_disabled, entity_id)
        subject
      end
    end
  end

  describe 'enabled?' do
    subject { super().enabled?(entity_id) }

    let(:entity_id) { 'abc' }

    context 'enabled entity' do
      before { manager.enable(entity_id) }

      it 'returns true' do
        expect(subject).to be_truthy
      end
    end

    context 'unknown entity' do
      before { manager.disable(entity_id) }

      it 'returns false' do
        expect(subject).to be_falsey
      end
    end
  end
end
