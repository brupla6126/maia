require 'virtus'
require 'araignee/architecture/storages/memory_kv'

include Araignee::Architecture

class MyEntity
  include Virtus.model

  attribute :id, String
end

RSpec.describe Storages::MemoryKV do
  let(:storage) { Storages::MemoryKV.new }

  describe '#initialize' do
    it 'should have entities empty' do
      expect(Storages::MemoryKV.new.entities.empty?).to eq(true)
    end
  end

  describe '#exists?' do
    let(:filter_match) { { id: 'abc' } }
    let(:filter_unmatch) { { id: 'xyz' } }

    before do
      storage.entities['abc'] = MyEntity.new(id: 'abc')
    end

    context 'when using matching filter' do
      it 'should return true' do
        expect(storage.exists?(filter_match)).to eq(true)
      end
    end

    context 'when using unmatching filter' do
      it 'should return false' do
        expect(storage.exists?(filter_unmatch)).to eq(false)
      end
    end
  end

  describe '#one' do
    let(:filter_match) { { id: 'abc' } }
    let(:filter_unmatch) { { id: 'xyz' } }
    let(:entity) { MyEntity.new(id: 'abc') }

    before do
      storage.entities['abc'] = entity
    end

    context 'when using matching filter' do
      it 'should return the entity' do
        expect(storage.one(filter_match)).to eq(entity)
      end
    end

    context 'when using unmatching filter' do
      it 'should return nil' do
        expect(storage.one(filter_unmatch)).to eq(nil)
      end
    end
  end

  describe '#many' do
    let(:filter) { { id: 'abc' } }
    let(:entity) { MyEntity.new(id: 'abc') }

    before do
      storage.entities['abc'] = entity
    end

    it 'should return entities' do
      expect(storage.many(filter).any?).to eq(true)
    end
  end

  describe '#create' do
    let(:filter) { { id: 'abc' } }
    let(:entity) { MyEntity.new(id: 'abc') }

    before do
      storage.create(entity)
    end

    it 'should have stored entity correctly' do
      expect(storage.entities.key?('abc')).to eq(true)
      expect(storage.entities['abc'].id).to eq('abc')
    end
  end

  describe '#delete' do
    let(:filter) { { id: 'abc' } }
    let(:entity) { MyEntity.new(id: 'abc') }

    before do
      storage.entities['abc'] = entity
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
        expect(storage.entities.key?('abc')).to eq(false)
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
end
