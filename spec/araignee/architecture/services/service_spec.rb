require 'araignee/architecture/entity'
require 'araignee/architecture/services/service'

include Araignee::Architecture

module Impl
  class Entity < Araignee::Architecture::Entity
  end
  class Service
    include Araignee::Architecture::Service

    def sibling(type)
      sibling_class(type)
    end

    def repo
      repository
    end

    def valid
      validator
    end
  end
  class Validator < Araignee::Architecture::Validator
  end
end

RSpec.describe Service do
  describe '#sibling_class' do
    context 'when valid class' do
      let(:result) { Impl::Service.new.sibling(:entity) }

      it 'should be correct class type' do
        expect(result).to eq(Impl::Entity)
      end
    end
    context 'when invalid class' do
      let(:service) { Impl::Service.new }

      it 'should raise NameError' do
        expect { service.sibling(:pusher) }.to raise_error(NameError)
      end
    end
  end

  describe '#repository' do
    after do
      Repository.clean
    end
    context 'when valid class' do
      let(:service) { Impl::Service.new }

      it 'should return object' do
        storage = 1
        Repository.register(Impl::Entity, storage)

        expect(service.repo).to eq(storage)
      end
    end
  end

  describe '#validator' do
    context 'when valid class' do
      let(:service) { Impl::Service.new }

      it 'should be correct class type' do
        expect(service.valid).to be_a(Impl::Validator)
      end
    end
  end
end
