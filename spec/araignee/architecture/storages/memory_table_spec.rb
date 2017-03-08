require 'virtus'
require 'araignee/architecture/storages/memory_table'

include Araignee::Architecture

class MyEntity
  include Virtus.model

  attribute :id, String
  attribute :name, String, default: ''
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
    let(:entity) { MyEntity.new(id: 'abc', name: 'ABC') }

    before do
      storage.entities << entity
    end

    context 'when using matching filter' do
      let(:filter_match_id) { { id: 'abc' } }
      let(:filter_match_name) { { name: 'ABC' } }

      it 'should find the entity by id' do
        expect(storage.one(filter_match_id)).to eq(entity)
      end

      it 'should find the entity by name' do
        expect(storage.one(filter_match_name)).to eq(entity)
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
    let(:filter_name) { { name: 'ABC' } }
    let(:entity1) { MyEntity.new(id: 'abc', name: 'ABC') }
    let(:entity2) { MyEntity.new(id: 'xyz', name: 'XYZ') }

    before do
      storage.entities << entity1
      storage.entities << entity2
    end

    context 'when using matching filter' do
      it 'should find the entity by id' do
        expect(storage.many(filter_id)).to eq([entity1])
      end

      it 'should find the entity by name' do
        expect(storage.many(filter_name)).to eq([entity1])
      end
    end

    context 'when using empty filter' do
      it 'should return all entities' do
        expect(storage.many({})).to eq([entity1, entity2])
      end
    end
  end

  describe '#create' do
    let(:name) { 'abc' }
    let(:entity) { MyEntity.new(name: name) }

    before do
      storage.create(entity)
    end

    it 'should have stored entity correctly' do
      entity = storage.entities.select { |e| e.name == name }[0]

      expect(entity.id).to eq(Digest::MD5.hexdigest(name))
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

      it 'should return 1' do
        expect(result).to eq(1)
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

      it 'should return 0' do
        expect(result).to eq(0)
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
