require 'araignee/architecture/entity'
require 'araignee/architecture/services/finder'
require 'araignee/architecture/storages/memory_kv'

include Araignee::Architecture
include Araignee::Architecture::Services

RSpec.describe Finder do
  module Impl
    class Entity < Araignee::Architecture::Entity
      attribute :id, Integer
      attribute :name, String
    end
  end

  let(:finder) { Finder.instance }

  before do
    Repository.register(Impl::Entity) do |helpers|
      helpers[:finder] = Finder.instance
      helpers[:storage] = Storages::MemoryKV.new
    end
  end

  after do
    Repository.clean
  end

  describe '#one' do
    after do
      Repository.clean
    end

    context 'without klass' do
      let(:params) { { filters: {} } }

      it 'should raise ArgumentError, filters empty' do
        expect { finder.one(params) }.to raise_error(ArgumentError, 'klass invalid')
      end
    end

    context 'without filters' do
      let(:params) { { klass: Impl::Entity } }

      it 'should raise ArgumentError, filters empty' do
        expect { finder.one(params) }.to raise_error(ArgumentError, 'filters empty')
      end
    end

    context 'with unmatched filters' do
      let(:filters) { { name: 'bill' } }
      let(:params) { { klass: Impl::Entity, filters: filters } }
      let(:result) { finder.one(params) }

      it 'should return nil entity' do
        storage = double('storage')
        Repository.register(Impl::Entity, :storage, storage)

        expect(storage).to receive(:one).once.and_return(nil)
        expect(result).to be_a(Finder::Result)
        expect(result.successful?).to eq(true)
        expect(result.entity).to eq(nil)
      end
    end

    context 'with matched filters' do
      let(:filters) { { id: 1, name: 'joe' } }
      let(:params) { { klass: Impl::Entity, filters: filters } }
      let(:result) { finder.one(params) }

      it 'should return valid entity' do
        storage = double('storage')
        Repository.register(Impl::Entity, :storage, storage)

        expect(storage).to receive(:one).once.and_return(id: 1, name: 'joe')
        expect(result).to be_a(Finder::Result)
        expect(result.successful?).to eq(true)
        expect(result.entity.id).to eq(1)
        expect(result.entity.name).to eq('joe')
      end
    end
  end

  describe '#many' do
    after do
      Repository.clean
    end

    context 'with unmatched filters' do
      let(:params) { { klass: Impl::Entity, filters: { name: 'joe' } } }
      let(:result) { finder.many(params) }

      it 'should return nil entity' do
        storage = double('storage')
        Repository.register(Impl::Entity, :storage, storage)

        expect(storage).to receive(:many).once.and_return([])
        expect(result).to be_a(Finder::Result)
        expect(result.successful?).to eq(true)
        expect(result.entities.empty?).to eq(true)
      end
    end

    context 'with matched filters' do
      let(:params) { { klass: Impl::Entity, filters: { name: 'joe' } } }
      let(:result) { finder.many(params) }

      it 'should return valid entity' do
        storage = double('storage')
        Repository.register(Impl::Entity, :storage, storage)

        expect(storage).to receive(:many).once.and_return([{ id: 1, name: 'joe bambu' }, { id: 2, name: 'joe pantoufle' }])
        expect(result).to be_a(Finder::Result)
        expect(result.successful?).to eq(true)
        expect(result.filters).not_to eq(nil)
        expect(result.entities.size).to eq(2)
      end
    end

    context 'with matched filters and pagination' do
      let(:params) { { klass: Impl::Entity, filters: { name: 'joe' }, sort: :name_asc, limit: 10 } }
      let(:result) { finder.many(params) }

      it 'should return valid entity' do
        storage = double('storage')
        Repository.register(Impl::Entity, :storage, storage)

        expect(storage).to receive(:many).once.and_return([{ id: 1, name: 'joe bambu' }, { id: 2, name: 'joe pantoufle' }])
        expect(result).to be_a(Finder::Result)
        expect(result.successful?).to eq(true)
        expect(result.filters).not_to eq(nil)
        expect(result.entities.size).to eq(2)
      end
    end
  end
end

RSpec.describe Finder::Result do
  describe '#initialize' do
    context 'when klass invalid' do
      it 'should raise ArgumentError' do
        expect { Finder::Result.new(nil, {}) }.to raise_error(ArgumentError, 'klass must be set')
      end
    end

    context 'when filters empty' do
      it 'should raise ArgumentError filters must be set' do
        expect { Finder::Result.new(Impl::Entity, {}, [], []) }.to raise_error(ArgumentError, 'filters must be set')
      end
    end

    context 'when filters not empty' do
      let(:result) { Finder::Result.new(Impl::Entity, { a: 1 }, nil, [], []) }
      it 'result filters should be set' do
        expect(result.filters).to eq(a: 1)
      end
    end

    context 'when entities set empty' do
      let(:result) { Finder::Result.new(Impl::Entity, { a: 1 }, nil, [], []) }
      it 'result entities should be empty' do
        expect(result.entities).to eq([])
      end
    end

    context 'when entities not empty' do
      let(:result) { Finder::Result.new(Impl::Entity, { a: 1 }, nil, [1], []) }
      it 'result entities should be set' do
        expect(result.entities).to eq([1])
      end
    end

    context 'when messages set empty' do
      let(:result) { Finder::Result.new(Impl::Entity, { a: 1 }, nil, [1], []) }
      it 'result messages should equal []' do
        expect(result.messages).to eq([])
      end
    end

    context 'when messages not empty' do
      let(:result) { Finder::Result.new(Impl::Entity, { a: 1 }, nil, [1], ['abc']) }
      it 'result messages should be set' do
        expect(result.messages).to eq(['abc'])
      end
    end
  end

  describe '#successful?' do
    let(:result) { Finder::Result.new(Impl::Entity, { a: 1 }, nil, [], []) }
    let(:result_error) { Finder::Result.new(Impl::Entity, { a: 1 }, nil, [], ['error 1']) }

    context 'when messages empty' do
      it 'should return true' do
        expect(result.successful?).to eq(true)
      end
    end

    context 'when messages is set' do
      it 'should return false' do
        expect(result_error.successful?).to eq(false)
      end
    end
  end
end
