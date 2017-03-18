require 'virtus'
require 'araignee/architecture/storages/memory_table'

include Araignee::Architecture

class MyEntity
  include Virtus.model

  attribute :id, String
  attribute :identifier, String, default: ''
end

RSpec.describe Storages::MemoryTable do
  let(:storage) { Storages::MemoryTable.new }

  describe '#initialize' do
    it 'should have entities empty' do
      expect(Storages::MemoryTable.new.entities.empty?).to eq(true)
    end
  end

  describe '#exists?' do
    before do
      storage.entities << MyEntity.new(id: 'abc')
    end

    context 'when using matching filter' do
      let(:filter_match) { { id: 'abc' } }

      it 'should return true' do
        expect(storage.exists?(filter_match)).to eq(true)
      end
    end

    context 'when using unmatching filter' do
      let(:filter_unmatch) { { id: 'xyz' } }

      it 'should return false' do
        expect(storage.exists?(filter_unmatch)).to eq(false)
      end
    end
  end

  describe '#one' do
    let(:entity) { MyEntity.new(id: 'abc', identifier: 'ABC') }

    before do
      storage.entities << entity
    end

    context 'when using matching filter' do
      let(:filter_match_id) { { id: 'abc' } }
      let(:filter_match_identifier) { { identifier: 'ABC' } }

      it 'should find the entity by id' do
        expect(storage.one(filter_match_id)).to eq(entity)
      end

      it 'should find the entity by identifier' do
        expect(storage.one(filter_match_identifier)).to eq(entity)
      end
    end

    context 'when using unmatching filter' do
      let(:filter_unmatch) { { id: 'xyz' } }

      it 'should return nil' do
        expect(storage.one(filter_unmatch)).to eq(nil)
      end
    end
  end

  describe '#many' do
    let(:filter_id) { { id: 'abc' } }
    let(:filter_identifier) { { identifier: 'ABC' } }
    let(:entity1) { MyEntity.new(id: 'abc', identifier: 'ABC') }
    let(:entity2) { MyEntity.new(id: 'xyz', identifier: 'XYZ') }

    before do
      storage.entities << entity1
      storage.entities << entity2
    end

    context 'when using matching filter' do
      it 'should find the entity by id' do
        expect(storage.many(filter_id)).to eq([entity1])
      end

      it 'should find the entity by identifier' do
        expect(storage.many(filter_identifier)).to eq([entity1])
      end
    end

    context 'when using empty filter' do
      it 'should return all entities' do
        expect(storage.many({})).to eq([entity1, entity2])
      end
    end
  end

  describe '#create' do
    let(:identifier) { 'abc' }
    let(:entity) { MyEntity.new(identifier: identifier) }

    before do
      storage.create(entity)
    end

    context 'id not set in entity' do
      it 'should generate entity id' do
        entity = storage.entities.select { |e| e.identifier == identifier }[0]

        expect(entity.id).not_to eq(nil)
      end
    end

    context 'id already set in entity' do
      let(:id) { 'abc' }
      let(:entity) { MyEntity.new(id: id, identifier: identifier) }

      it 'should not generate entity id' do
        entity = storage.entities.select { |e| e.identifier == identifier }[0]

        expect(entity.id).to eq(id)
      end
    end
  end

  describe '#update' do
    let(:entity) { MyEntity.new(id: 'abc') }

    before do
      storage.update(entity)
    end

    it 'should have stored entity correctly' do
      expect(storage.entities.select { |entity| entity.id == 'abc' }.any?).to eq(true)
    end
  end

  describe '#delete' do
    let(:filter) { { id: 'abc' } }
    let(:entity) { MyEntity.new(id: 'abc') }

    before do
      storage.entities << entity
    end

    context 'with existing entity' do
      result = nil
      before do
        result = storage.delete(id: 'abc')
      end

      it 'should return the entity' do
        expect(result).to eq(entity)
      end
      it 'should have removed entity' do
        expect(storage.entities.select { |entity| entity.id == 'abc' }.any?).to eq(false)
      end
    end

    context 'with inexisting entity' do
      result = nil
      before do
        result = storage.delete(id: 'xyz')
      end

      it 'should return nil' do
        expect(result).to eq(nil)
      end
    end
  end

  describe '#clear' do
    let(:entity) { MyEntity.new(id: 'abc') }

    before do
      storage.entities << entity
      storage.clear
    end

    it 'should be empty' do
      expect(storage.entities.count).to eq(0)
    end
  end
end
