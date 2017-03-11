require 'araignee/architecture/entity'
require 'araignee/architecture/helpers/updater'
require 'araignee/architecture/storages/memory_kv'

include Araignee::Architecture
include Araignee::Architecture::Helpers

module Impl
  class Entity < Araignee::Architecture::Entity
    attribute :id, Integer
    attribute :name, String
  end
end

class UpdaterImplError < Updater
  def update
    Result.new(Impl::Entity, @id, @entity, %w(a))
  end
end

RSpec.describe Updater do
  let(:filters) { { name: 'joe' } }
  let(:updater) { Updater.instance }

  before do
    Repository.register(Impl::Entity) do |helpers|
      helpers[:finder] = Finder.instance
      helpers[:storage] = Storages::MemoryKV.new
      helpers[:validator] = Validator.instance
    end
  end

  after do
    Repository.clean
  end

  describe '#update' do
    let(:params) { { klass: Impl::Entity, id: 1, attributes: { name: 'blow' } } }
    let(:result) { updater.update(params) }

    after do
      Repository.clean
    end

    context 'when id invalid' do
      let(:params) { { klass: Impl::Entity, attributes: { name: 'blow' } } }

      it 'should update the entity successfully' do
        expect { updater.update(params) }.to raise_error(ArgumentError, 'id invalid')
      end
    end

    context 'when attributes empty' do
      let(:params) { { klass: Impl::Entity, id: 1, attributes: {} } }

      it 'should update the entity successfully' do
        expect { updater.update(params) }.to raise_error(ArgumentError, 'attributes empty')
      end
    end

    context 'when entity is not in storage' do
      it 'should update the entity successfully' do
        storage = double('storage')
        Repository.register(Impl::Entity, :storage, storage)

        expect(storage).to receive(:one).once.and_return(id: 1, name: 'joe')
        expect(storage).to receive(:update).once
        expect(result).to be_a(Updater::Result)
        expect(result.successful?).to eq(true)
        expect(result.entity.name).to eq('blow')
      end
    end

    context 'when entity is already in storage' do
      before do
        Repository.for(Impl::Entity, :storage).create(Impl::Entity.new(params))
      end

      it 'should update the entity successfully' do
        storage = double('storage')
        Repository.register(Impl::Entity, :storage, storage)

        expect(storage).to receive(:one).once.and_return(id: 1, name: 'joe')
        expect(storage).to receive(:update).once
        expect(result).to be_a(Updater::Result)
        expect(result.successful?).to eq(true)
        expect(result.entity.name).to eq('blow')
      end
    end

    context 'when implemented class with errors' do
      let(:result) { UpdaterImplError.instance.update }

      it 'should return a Updater::Result' do
        expect(result).to be_a(Updater::Result)
      end

      it 'should not be successful' do
        expect(result.successful?).to eq(false)
      end
    end
  end
end

RSpec.describe Updater::Result do
  describe '#initialize' do
    let(:result) { Updater::Result.new(Impl::Entity, 1, {}, []) }

    context 'when name not set' do
      it 'should raise ArgumentError name must be set' do
        expect(result.entity).to eq({})
        expect(result.messages).to eq([])
      end
    end
    context 'when messages not set' do
      it 'should default to []' do
        expect(result.messages).to eq([])
      end
    end
  end

  describe '#successful?' do
    let(:result) { Updater::Result.new(Impl::Entity, 1, {}, []) }
    let(:result_error) { Updater::Result.new(Impl::Entity, 1, {}, ['error 1']) }

    context 'when messages not set' do
      it 'should default to []' do
        expect(result.messages).to eq([])
      end
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
