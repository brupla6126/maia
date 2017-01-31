require 'araignee/architecture/entity'
require 'araignee/architecture/services/updater'

include Araignee::Architecture

module Impl
  class Entity < Araignee::Architecture::Entity
    attribute :name, String
  end
  class Finder < Araignee::Architecture::Finder
  end
  class Updater < Araignee::Architecture::Updater
  end
  class Validator < Araignee::Architecture::Validator
  end
end

class UpdaterImplError < Araignee::Architecture::Updater
  def update
    Result.new(@id, @entity, %w(a))
  end
end

RSpec.describe Updater do
  describe '#execute' do
    context 'when abstract class' do
      it 'should raise NotImplementedError' do
        expect { Updater.instance.execute(1, name: 'joe') }.to raise_error(NotImplementedError)
      end
    end

    context 'when implemented class' do
      let(:result) { Impl::Updater.instance.execute(1, name: 'blow') }

      after do
        Repository.clean
      end

      it 'should update the entity successfully' do
        storage = double('storage')
        Repository.register(Impl::Entity, storage)

        expect(storage).to receive(:one).once.and_return(id: 1, name: 'joe')
        expect(storage).to receive(:save).once
        expect(result).to be_a(Updater::Result)
        expect(result.successful?).to eq(true)
        expect(result.entity.name).to eq('blow')
      end
    end

    context 'when implemented class with errors' do
      let(:result) { UpdaterImplError.instance.execute(1, name: 'joe') }

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
    let(:result) { Updater::Result.new(1, {}, []) }

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
    let(:result) { Updater::Result.new(1, {}, []) }
    let(:result_error) { Updater::Result.new(1, {}, ['error 1']) }

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
