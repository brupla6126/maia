require 'araignee/stories/entity'
require 'araignee/stories/storages/memory'

RSpec.describe Araignee::Stories::Storages::Memory do
  let(:memory) { described_class.new }

  let(:attributes) { { id: 'abc' } }
  let(:entity) { Araignee::Stories::Entity.new(attributes: attributes) }
  subject { memory }

  describe '#initialize' do
    it 'should have entities empty' do
      expect(subject.entities.empty?).to eq(true)
    end
  end

  describe '#exists?' do
    subject { super().exists?(filter) }

    before do
      memory.entities << entity
    end

    context 'when using matching filter' do
      let(:filter) { { id: 'abc' } }

      it 'returns true' do
        expect(subject).to eq(true)
      end
    end

    context 'when using unmatching filter' do
      let(:filter) { { id: 'xyz' } }

      it 'returns false' do
        expect(subject).to eq(false)
      end
    end
  end

  describe '#one' do
    let(:attributes) { { id: 'abc', identifier: 'ABC' } }

    before do
      memory.entities << entity
    end

    context 'when using matching filter' do
      let(:filter_match_id) { { id: 'abc' } }
      let(:filter_match_identifier) { { identifier: 'ABC' } }

      it 'finds the entity by id' do
        expect(memory.one(filter_match_id)).to eq(entity)
      end

      it 'finds the entity by identifier' do
        expect(memory.one(filter_match_identifier)).to eq(entity)
      end
    end

    context 'when using unmatching filter' do
      let(:filter) { { id: 'xyz' } }

      it 'returns nil' do
        expect(memory.one(filter)).to eq(nil)
      end
    end
  end

  describe '#many' do
    let(:filter_id) { { id: 'abc' } }
    let(:filter_identifier) { { identifier: 'ABC' } }
    let(:filter_context) { { context: 'abc' } }
    let(:filter_context_identifier) { { identifier: 'ABC', context: 'abc' } }

    let(:entity1) { Araignee::Stories::Entity.new(attributes: { id: 'abc', identifier: 'ABC', context: 'abc' }) }
    let(:entity2) { Araignee::Stories::Entity.new(attributes: { id: 'def', identifier: 'DEF', context: 'abc' }) }
    let(:entity3) { Araignee::Stories::Entity.new(attributes: { id: 'xyz', identifier: 'XYZ', context: 'xyz' }) }

    before do
      memory.entities << entity1 << entity2 << entity3
    end

    context 'when using matching filter' do
      it 'finds the entity by id' do
        expect(memory.many(filter_id)).to eq([entity1])
      end

      it 'finds the entity by identifier' do
        expect(memory.many(filter_identifier)).to eq([entity1])
      end

      it 'finds the entity by context and identifier' do
        expect(memory.many(filter_context_identifier)).to eq([entity1])
      end

      it 'finds entities by context' do
        expect(memory.many(filter_context)).to eq([entity1, entity2])
      end
    end

    context 'when using empty filters' do
      it 'returns all entities' do
        expect(memory.many({})).to eq([entity1, entity2, entity3])
      end
    end
  end

  describe '#create' do
    let(:identifier) { 'abc' }
    let(:attributes) { { identifier: identifier } }

    before do
      memory.create(entity)
    end

    context 'id not set in entity' do
      it 'should generate entity id' do
        entity = memory.entities.select { |e| e.identifier == identifier }[0]

        expect(entity.id).not_to eq(nil)
      end
    end

    context 'id already set in entity' do
      let(:id) { 'abc' }
      let(:attributes) { { id: id, identifier: identifier } }

      it 'should not generate entity id' do
        entity = memory.entities.select { |e| e.identifier == identifier }[0]

        expect(entity.id).to eq(id)
      end
    end
  end

  describe '#update' do
    before do
      memory.update(entity)
    end

    it 'should have stored entity correctly' do
      expect(memory.entities.select { |entity| entity.id == 'abc' }.any?).to eq(true)
    end
  end

  describe '#delete' do
    let(:filter) { { id: 'abc' } }

    before do
      memory.entities << entity
    end

    context 'with existing entity' do
      result = nil
      before do
        result = memory.delete(id: 'abc')
      end

      it 'returns the entity' do
        expect(result).to eq(entity)
      end
      it 'should have removed entity' do
        expect(memory.entities.select { |entity| entity.id == 'abc' }.any?).to eq(false)
      end
    end

    context 'with inexisting entity' do
      result = nil
      before do
        result = memory.delete(id: 'xyz')
      end

      it 'returns nil' do
        expect(result).to eq(nil)
      end
    end
  end

  describe '#clear' do
    before do
      memory.entities << entity
      memory.clear
    end

    it 'should be empty' do
      expect(memory.entities.size).to eq(0)
    end
  end
end
