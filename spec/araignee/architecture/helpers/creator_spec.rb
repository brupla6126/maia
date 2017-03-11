require 'araignee/architecture/entity'
require 'araignee/architecture/helpers/creator'
require 'araignee/architecture/storages/memory_kv'

include Araignee::Architecture
include Araignee::Architecture::Helpers

module Impl
  class Entity < Araignee::Architecture::Entity
    attribute :id, Integer
    attribute :name, String
  end
end

RSpec.describe Creator do
  let(:filters) { { name: 'joe' } }
  let(:creator) { Creator.instance }

  before do
    Repository.register(Impl::Entity) do |helpers|
      helpers[:validator] = Validator.instance
      helpers[:storage] = Storages::MemoryKV.new
    end
  end

  after do
    Repository.clean
  end

  describe '#create' do
    context 'without klass' do
      let(:params) { { attributes: { name: 'joe', age: 32 } } }

      it 'should raise ArgumentError, filters empty' do
        expect { creator.create(params) }.to raise_error(ArgumentError, 'klass invalid')
      end
    end

    context 'when attributes empty' do
      let(:params) { { klass: Impl::Entity } }

      it 'should raise ArgumentError' do
        expect { creator.create(params) }.to raise_error(ArgumentError, 'attributes empty')
      end
    end

    context 'when id & attributes valid' do
      let(:params) { { klass: Impl::Entity, attributes: { name: 'joe', age: 32 } } }
      let(:result) { creator.create(params) }

      after do
        Repository.clean
      end

      it 'should have successfully created entity named joe' do
        storage = double('storage')
        Repository.register(Impl::Entity, :storage, storage)

        expect(storage).to receive(:create).once
        expect(result).to be_a(Creator::Result)
        expect(result.successful?).to eq(true)
        expect(result.entity.name).to eq('joe')
      end
    end
  end
end

RSpec.describe Creator::Result do
  describe '#initialize' do
    let(:result) { Creator::Result.new(Impl::Entity, {}, []) }

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
    let(:result) { Creator::Result.new(Impl::Entity, {}, []) }
    let(:result_error) { Creator::Result.new(Impl::Entity, {}, ['error 1']) }

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
