require 'artemisia/component'
require 'artemisia/managers/component_manager'

RSpec.describe Artemisia::Managers::ComponentManager do
  class MyComponentManager < Artemisia::Managers::ComponentManager
    attr_accessor :components
  end

  let(:manager) { MyComponentManager.new(attributes) }
  let(:attributes) { OpenStruct.new }

  subject { manager }

  describe '#initialize' do
    it 'is initialized properly' do
      expect(subject.type).to eq(:component_manager)
      # expect(subject.group_entities.empty?).to be_truthy
      # expect(subject.entity_groups.empty?).to be_truthy
    end
  end

  describe '#add_component' do
    subject { super().add_component(entity_id, component) }

    let(:entity_id) { 'abc' }
    let(:component) { Artemisia::Component.new(type: 'location', x: 1, y: 2) }

    it 'adds the component' do
      expect(subject.components[component.type]).to include(entity_id)
    end

    it 'emits the :component_added_to_entity event' do
      expect(manager).to receive(:emit).with(:component_added_to_entity, entity_id, component)
      subject
    end

    it 'return itself' do
      expect(subject).to eq(manager)
    end
  end

  describe '#remove_component' do
    subject { super().remove_component(entity_id, component) }

    let(:entity_id) { 'abc' }
    let(:component) { Artemisia::Component.new(type: 'location', x: 1, y: 2) }

    before { manager.add_component(entity_id, component) }

    it 'removes the component' do
      expect(subject.components[component.type]).not_to include(entity_id)
    end

    it 'emits the :component_removes_from_entity event' do
      expect(manager).to receive(:emit).with(:component_removed_from_entity, entity_id, component)
      subject
    end

    it 'return itself' do
      expect(subject).to eq(manager)
    end
  end

  describe '#component' do
    subject { super().component(entity_id, component_type) }

    let(:entity_id) { 'abc' }
    let(:component) { Artemisia::Component.new(type: 'location', x: 1, y: 2) }
    let(:component_type) { :unknown }

    context 'unknown component type' do
      it 'returns nil' do
        expect(subject).to eq(nil)
      end
    end

    context 'known component type' do
      let(:component_type) { 'location' }

      context 'unknown entity' do
        before { manager.add_component('xyz', component) }

        it 'returns nil' do
          expect(subject).to eq(nil)
        end
      end

      context 'known entity' do
        before { manager.add_component(entity_id, component) }

        context 'unknown component' do
          let(:component_type) { 'movement' }

          it 'returns nil' do
            expect(subject).to eq(nil)
          end
        end

        context 'known component' do
          it 'returns the component' do
            expect(subject).to eq(component)
          end
        end
      end
    end
  end

  describe '#all_components' do
    subject { super().all_components(component_type) }

    let(:entity1_id) { 'abc' }
    let(:entity2_id) { 'xyz' }
    let(:location1) { { type: 'location', x: 1, y: 2 } }
    let(:location2) { { type: 'location', x: 10, y: 20 } }
    let(:movement) { { type: 'movement', dx: 1, dy: 2, dz: 3 } }
    let(:component1) { Artemisia::Component.new(location1) }
    let(:component2) { Artemisia::Component.new(location2) }
    let(:component3) { Artemisia::Component.new(movement) }
    let(:component_type) { 'unknown' }

    before do
      manager.add_component(entity1_id, component1)
      manager.add_component(entity2_id, component2)
      manager.add_component(entity2_id, component3)
    end

    context 'unknown component type' do
      it 'returns empty list of components' do
        expect(subject).to eq([])
      end
    end

    context 'known component type' do
      let(:component_type) { 'location' }

      it 'returns list of components' do
        expect(subject).to match([component1, component2])
      end
    end
  end
end
