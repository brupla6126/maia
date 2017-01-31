require 'araignee/architecture/entity'
require 'araignee/architecture/services/creator'

include Araignee::Architecture

module Impl
  class Entity < Araignee::Architecture::Entity
    attribute :name, String
  end
  class Creator < Araignee::Architecture::Creator
  end
  class Validator < Araignee::Architecture::Validator
  end
end

RSpec.describe Creator do
  describe '#execute' do
    context 'when base class' do
      it 'should raise NotImplementedError, must derive this class' do
        expect { Creator.instance.execute(name: 'joe') }.to raise_error(NotImplementedError, 'must derive this class')
      end
    end
    context 'when implemented class' do
      let(:result) { Impl::Creator.instance.execute(name: 'joe') }

      after do
        Repository.clean
      end

      it 'should have successfully created entity named joe' do
        storage = double('storage')
        Repository.register(Impl::Entity, storage)

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
    let(:result) { Creator::Result.new({}, []) }

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
    let(:result) { Creator::Result.new({}, []) }
    let(:result_error) { Creator::Result.new({}, ['error 1']) }

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
