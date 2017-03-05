require 'araignee/architecture/entity'
require 'araignee/architecture/services/deleter'

include Araignee::Architecture
include Araignee::Architecture::Services

module Impl
  class Entity < Araignee::Architecture::Entity
    attribute :id, Integer
    attribute :name, String
  end
end

RSpec.describe Deleter do
  let(:filters) { { name: 'joe' } }
  let(:deleter) { Deleter.instance }

  after do
    Repository.clean
  end

  describe '#delete' do
    after do
      Repository.clean
    end

    context 'without klass' do
      let(:params) { { filters: filters } }

      it 'should raise ArgumentError, klass invalid' do
        expect { deleter.delete(params) }.to raise_error(ArgumentError, 'klass invalid')
      end
    end

    context 'without filters' do
      let(:params) { { klass: Impl::Entity, filters: {} } }

      it 'should raise ArgumentError, filters empty' do
        expect { deleter.delete(params) }.to raise_error(ArgumentError, 'filters empty')
      end
    end

    context 'with unmatched filters' do
      let(:filters) { { name: 'joe' } }
      let(:params) { { klass: Impl::Entity, filters: filters } }
      let(:result) { deleter.delete(params) }

      it 'should return nil' do
        storage = double('storage')
        Repository.register(Impl::Entity, :storage, storage)

        expect(storage).to receive(:delete).once.and_return(nil)
        expect(result).to be_a(Deleter::Result)
        expect(result.successful?).to eq(true)
        expect(result.response).to eq(nil)
      end
    end

    context 'with matched filters' do
      let(:params) { { klass: Impl::Entity, filters: { name: 'bill' } } }
      let(:result) { deleter.delete(params) }

      it 'should delete entity and return 1' do
        storage = double('storage')
        Repository.register(Impl::Entity, :storage, storage)

        expect(storage).to receive(:delete).once.and_return(1)
        expect(result).to be_a(Deleter::Result)
        expect(result.successful?).to eq(true)
        expect(result.response).to eq(1)
      end
    end
  end
end

RSpec.describe Deleter::Result do
  describe '#initialize' do
    context 'when filters empty' do
      it 'should raise ArgumentError filters empty' do
        expect { Deleter::Result.new(Impl::Entity, {}, nil, []) }.to raise_error(ArgumentError, 'filters empty')
      end
    end

    context 'when filters not empty' do
      let(:result) { Deleter::Result.new(Impl::Entity, { a: 1 }, nil, []) }
      it 'result filters should be set' do
        expect(result.filters).to eq(a: 1)
      end
    end

    context 'when response not set' do
      let(:result) { Deleter::Result.new(Impl::Entity, { a: 1 }, nil, []) }
      it 'result entities should be empty' do
        expect(result.response).to eq(nil)
      end
    end

    context 'when response set' do
      let(:result) { Deleter::Result.new(Impl::Entity, { a: 1 }, 1, []) }
      it 'result response should be set' do
        expect(result.response).to eq(1)
      end
    end

    context 'when messages set empty' do
      let(:result) { Deleter::Result.new(Impl::Entity, { a: 1 }, nil, []) }
      it 'result messages should equal []' do
        expect(result.messages).to eq([])
      end
    end

    context 'when messages not empty' do
      let(:result) { Deleter::Result.new(Impl::Entity, { a: 1 }, nil, ['abc']) }
      it 'result messages should be set' do
        expect(result.messages).to eq(['abc'])
      end
    end
  end

  describe '#successful?' do
    let(:result) { Deleter::Result.new(Impl::Entity, { a: 1 }, nil, []) }
    let(:result_error) { Deleter::Result.new(Impl::Entity, { a: 1 }, nil, ['error 1']) }

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
