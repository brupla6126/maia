require 'araignee/architecture/entity'
require 'araignee/architecture/services/service'

include Araignee::Architecture
include Araignee::Architecture::Services

module Impl
  class Entity < Araignee::Architecture::Entity
  end

  class Service
    include Araignee::Architecture::Services::Service
  end
end

RSpec.describe Service do
  let(:service) { Impl::Service.new }

  before do
    Repository.register(Impl::Entity) do |helpers|
      helpers[:validator] = Validator.instance
    end
  end

  after do
    Repository.clean
  end

  describe '#creator' do
    context 'when Creator instance NOT set in repository' do
      it 'should return Creator.instance' do
        expect(service.send(:creator, Impl::Entity)).to eq(Creator.instance)
      end
    end

    context 'when Creator instance set in repository' do
      let(:creator) { 1 }

      before { Repository.register(Impl::Entity, :creator, creator) }

      it 'should return Creator instance registered in Repository' do
        expect(service.send(:creator, Impl::Entity)).to eq(creator)
      end
    end
  end

  describe '#finder' do
    context 'when Finder instance NOT set in repository' do
      it 'should return Finder.instance' do
        expect(service.send(:finder, Impl::Entity)).to eq(Finder.instance)
      end
    end

    context 'when Finder instance set in repository' do
      let(:finder) { 1 }

      before { Repository.register(Impl::Entity, :finder, finder) }

      it 'should return Finder instance registered in Repository' do
        expect(service.send(:finder, Impl::Entity)).to eq(finder)
      end
    end
  end

  describe '#deleter' do
    context 'when Deleter instance NOT set in repository' do
      it 'should return Deleter.instance' do
        expect(service.send(:deleter, Impl::Entity)).to eq(Deleter.instance)
      end
    end

    context 'when Deleter instance set in repository' do
      let(:deleter) { 1 }

      before { Repository.register(Impl::Entity, :deleter, deleter) }

      it 'should return Deleter instance registered in Repository' do
        expect(service.send(:deleter, Impl::Entity)).to eq(deleter)
      end
    end
  end

  describe '#storage' do
    context 'when Storage instance NOT set in repository' do
      it 'should return nil' do
        expect(service.send(:storage, Impl::Entity)).to eq(nil)
      end
    end

    context 'when Storage instance set in repository' do
      let(:storage) { 1 }

      before { Repository.register(Impl::Entity, :storage, storage) }

      it 'should return Storage instance registered in Repository' do
        expect(service.send(:storage, Impl::Entity)).to eq(storage)
      end
    end
  end

  describe '#updater' do
    context 'when Updater instance NOT set in repository' do
      it 'should return Updater.instance' do
        expect(service.send(:updater, Impl::Entity)).to eq(Updater.instance)
      end
    end

    context 'when Updater instance set in repository' do
      let(:updater) { 1 }

      before { Repository.register(Impl::Entity, :updater, updater) }

      it 'should return Updater instance registered in Repository' do
        expect(service.send(:updater, Impl::Entity)).to eq(updater)
      end
    end
  end

  describe '#validator' do
    context 'when Validator instance NOT set in repository' do
      it 'should return Validator.instance' do
        expect(service.send(:validator, Impl::Entity)).to eq(Validator.instance)
      end
    end

    context 'when Validator instance set in repository' do
      let(:validator) { 1 }

      before { Repository.register(Impl::Entity, :validator, validator) }

      it 'should return Validator instance registered in Repository' do
        expect(service.send(:validator, Impl::Entity)).to eq(validator)
      end
    end
  end
end
