require 'araignee/architecture/entity'
require 'araignee/architecture/services/aggregator'

include Araignee::Architecture

module Impl
  class Entity < Araignee::Architecture::Entity
    attribute :name, String
  end
  class Aggregator < Araignee::Architecture::Aggregator
  end
end

RSpec.describe Aggregator do
  describe '#execute' do
    context 'when base class' do
      it 'should raise NotImplementedError' do
        expect { Aggregator.instance.execute(name: 'joe') }.to raise_error(NotImplementedError)
      end
    end

    context 'when implemented class' do
      let(:result) { Impl::Aggregator.instance.execute(name: 'joe') }

      after do
        # Repository.clean
      end

      it 'should have successfully created entity named joe' do
        expect(result).to be_a(Aggregator::Result)
        expect(result.successful?).to eq(true)
      end
    end
  end
end

RSpec.describe Aggregator::Result do
  describe '#initialize' do
    let(:result) { Aggregator::Result.new({}, []) }

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
    let(:result) { Aggregator::Result.new({}, []) }
    let(:result_error) { Aggregator::Result.new({}, ['error 1']) }

    context 'when messages not set' do
      it 'should default to []' do
        expect(result.messages).to eq([])
      end
      it 'successful? should return true' do
        expect(result.successful?).to eq(true)
      end
    end

    context 'when messages is set' do
      it 'successful? should return false' do
        expect(result_error.successful?).to eq(false)
      end
    end
  end
end
