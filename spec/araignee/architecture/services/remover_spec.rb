require 'araignee/architecture/entity'
require 'araignee/architecture/services/remover'

include Araignee::Architecture

module Impl
  class Entity < Araignee::Architecture::Entity
    attribute :id, Integer
    attribute :name, String
  end
  class Remover < Araignee::Architecture::Remover
  end
end

RSpec.describe Remover do
  describe '#remove' do
    context 'when abstract class' do
      it 'should raise NotImplementedError' do
        expect { Remover.instance.execute(name: 'joe') }.to raise_error(NotImplementedError)
      end
    end

    context 'when implemented class' do
      after do
        Repository.clean
      end

      context 'without filters' do
        it 'should raise ArgumentError, filters empty' do
          expect { Impl::Remover.instance.execute({}) }.to raise_error(ArgumentError, 'filters empty')
        end
      end

      context 'with unmatched filters' do
        let(:result) { Impl::Remover.instance.execute(name: 'joe') }

        it 'should return nil' do
          storage = double('storage')
          Repository.register(Impl::Entity, storage)

          expect(storage).to receive(:delete).once.and_return(nil)
          expect(result).to be_a(Impl::Remover::Result)
          expect(result.successful?).to eq(true)
          expect(result.response).to eq(nil)
        end
      end

      context 'with matched filters' do
        let(:result) { Impl::Remover.instance.execute(name: 'joe') }

        it 'should remove entity and return 1' do
          storage = double('storage')
          Repository.register(Impl::Entity, storage)

          expect(storage).to receive(:delete).once.and_return(1)
          expect(result).to be_a(Impl::Remover::Result)
          expect(result.successful?).to eq(true)
          expect(result.response).to eq(1)
        end
      end
    end
  end
end

RSpec.describe Remover::Result do
  describe '#initialize' do
    context 'when filters empty' do
      it 'should raise ArgumentError filters empty' do
        expect { Remover::Result.new({}, nil, []) }.to raise_error(ArgumentError, 'filters empty')
      end
    end

    context 'when filters not empty' do
      let(:result) { Remover::Result.new({ a: 1 }, nil, []) }
      it 'result filters should be set' do
        expect(result.filters).to eq(a: 1)
      end
    end

    context 'when response not set' do
      let(:result) { Remover::Result.new({ a: 1 }, nil, []) }
      it 'result entities should be empty' do
        expect(result.response).to eq(nil)
      end
    end

    context 'when response set' do
      let(:result) { Remover::Result.new({ a: 1 }, 1, []) }
      it 'result response should be set' do
        expect(result.response).to eq(1)
      end
    end

    context 'when messages set empty' do
      let(:result) { Remover::Result.new({ a: 1 }, nil, []) }
      it 'result messages should equal []' do
        expect(result.messages).to eq([])
      end
    end

    context 'when messages not empty' do
      let(:result) { Remover::Result.new({ a: 1 }, nil, ['abc']) }
      it 'result messages should be set' do
        expect(result.messages).to eq(['abc'])
      end
    end
  end

  describe '#successful?' do
    let(:result) { Remover::Result.new({ a: 1 }, nil, []) }
    let(:result_error) { Remover::Result.new({ a: 1 }, nil, ['error 1']) }

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
