require 'araignee/architecture/entity'
require 'araignee/architecture/services/finder'
require 'araignee/architecture/services/validator'

include Araignee::Architecture

module Impl
  class Entity < Araignee::Architecture::Entity
    attribute :id, Integer
    attribute :name, String
  end
  class Finder < Araignee::Architecture::Finder
  end
  class Validator < Araignee::Architecture::Validator
  end
end

RSpec.describe Finder do
  describe '#one' do
    context 'when abstract class' do
      it 'should raise NotImplementedError' do
        expect { Finder.instance.one(name: 'joe') }.to raise_error(NotImplementedError)
      end
    end

    context 'when implemented class' do
      after do
        Repository.clean
      end

      context 'without filters' do
        it 'should raise ArgumentError, filters empty' do
          expect { Impl::Finder.instance.one({}) }.to raise_error(ArgumentError, 'filters empty')
        end
      end

      context 'with unmatched filters' do
        let(:result) { Impl::Finder.instance.one(name: 'joe') }

        it 'should return nil entity' do
          storage = double('storage')
          Repository.register(Impl::Entity, storage)

          expect(storage).to receive(:one).once.and_return(nil)
          expect(result).to be_a(Impl::Finder::Result)
          expect(result.successful?).to eq(true)
          expect(result.entity).to eq(nil)
        end
      end

      context 'with matched filters' do
        let(:result) { Impl::Finder.instance.one(name: 'joe') }

        it 'should return valid entity' do
          storage = double('storage')
          Repository.register(Impl::Entity, storage)

          expect(storage).to receive(:one).once.and_return(id: 1, name: 'joe')
          expect(result).to be_a(Impl::Finder::Result)
          expect(result.successful?).to eq(true)
          expect(result.entity.id).to eq(1)
          expect(result.entity.name).to eq('joe')
        end
      end
    end
  end

  describe '#many' do
    context 'when abstract class' do
      it 'should raise NotImplementedError' do
        expect { Finder.instance.many(name: 'joe') }.to raise_error(NotImplementedError)
      end
    end
    context 'when implemented class' do
      after do
        Repository.clean
      end

      context 'without filters' do
        it 'should raise ArgumentError, filters empty' do
          expect { Impl::Finder.instance.many({}) }.to raise_error(ArgumentError, 'filters empty')
        end
      end

      context 'with unmatched filters' do
        let(:result) { Impl::Finder.instance.many(name: 'joe') }

        it 'should return nil entity' do
          storage = double('storage')
          Repository.register(Impl::Entity, storage)

          expect(storage).to receive(:many).once.and_return([])
          expect(result).to be_a(Impl::Finder::Result)
          expect(result.successful?).to eq(true)
          expect(result.entities.empty?).to eq(true)
        end
      end

      context 'with matched filters' do
        let(:result) { Impl::Finder.instance.many(name: 'joe') }

        it 'should return valid entity' do
          storage = double('storage')
          Repository.register(Impl::Entity, storage)

          expect(storage).to receive(:many).once.and_return([{ id: 1, name: 'joe bambu' }, { id: 2, name: 'joe pantoufle' }])
          expect(result).to be_a(Impl::Finder::Result)
          expect(result.successful?).to eq(true)
          expect(result.filters).not_to eq(nil)
          expect(result.entities.size).to eq(2)
        end
      end

      context 'with matched filters and pagination' do
        let(:result) { Impl::Finder.instance.many({ name: 'joe' }, :asc, 10) }

        it 'should return valid entity' do
          storage = double('storage')
          Repository.register(Impl::Entity, storage)

          expect(storage).to receive(:many).once.and_return([{ id: 1, name: 'joe bambu' }, { id: 2, name: 'joe pantoufle' }])
          expect(result).to be_a(Impl::Finder::Result)
          expect(result.successful?).to eq(true)
          expect(result.filters).not_to eq(nil)
          expect(result.entities.size).to eq(2)
        end
      end
    end
  end
end

RSpec.describe Finder::Result do
  describe '#initialize' do
    context 'when filters empty' do
      it 'should raise ArgumentError filters must be set' do
        expect { Finder::Result.new({}, [], []) }.to raise_error(ArgumentError, 'filters must be set')
      end
    end

    context 'when filters not empty' do
      let(:result) { Finder::Result.new({ a: 1 }, nil, [], []) }
      it 'result filters should be set' do
        expect(result.filters).to eq(a: 1)
      end
    end

    context 'when entities set empty' do
      let(:result) { Finder::Result.new({ a: 1 }, nil, [], []) }
      it 'result entities should be empty' do
        expect(result.entities).to eq([])
      end
    end

    context 'when entities not empty' do
      let(:result) { Finder::Result.new({ a: 1 }, nil, [1], []) }
      it 'result entities should be set' do
        expect(result.entities).to eq([1])
      end
    end

    context 'when messages set empty' do
      let(:result) { Finder::Result.new({ a: 1 }, nil, [1], []) }
      it 'result messages should equal []' do
        expect(result.messages).to eq([])
      end
    end

    context 'when messages not empty' do
      let(:result) { Finder::Result.new({ a: 1 }, nil, [1], ['abc']) }
      it 'result messages should be set' do
        expect(result.messages).to eq(['abc'])
      end
    end
  end

  describe '#successful?' do
    let(:result) { Finder::Result.new({ a: 1 }, nil, [], []) }
    let(:result_error) { Finder::Result.new({ a: 1 }, nil, [], ['error 1']) }

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
