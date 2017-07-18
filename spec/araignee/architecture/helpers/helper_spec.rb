require 'araignee/architecture/entity'
require 'araignee/architecture/helpers/helper'

include Araignee::Architecture
include Araignee::Architecture::Helpers

module Impl
  class Entity < Araignee::Architecture::Entity
  end

  class Helper
    include Araignee::Architecture::Helpers::Helper
  end
end

RSpec.describe Helper do
  let(:helper) { Impl::Helper.new }

  before do
    Repository.register(Impl::Entity) do |helpers|
      helpers[:validator] = Validator.instance
    end
  end

  after do
    Repository.clean
  end

  describe '#storage' do
    context 'when Storage instance NOT set in repository' do
      it 'should return nil' do
        expect(helper.send(:storage, Impl::Entity)).to eq(nil)
      end
    end

    context 'when Storage instance set in repository' do
      let(:storage) { 1 }

      before { Repository.register(Impl::Entity, :storage, storage) }

      it 'should return Storage instance registered in Repository' do
        expect(helper.send(:storage, Impl::Entity)).to eq(storage)
      end
    end
  end

  describe '#validator' do
    context 'when Validator instance NOT set in repository' do
      it 'should return Validator.instance' do
        expect(helper.send(:validator, Impl::Entity)).to eq(Validator.instance)
      end
    end

    context 'when Validator instance set in repository' do
      let(:validator) { 1 }

      before { Repository.register(Impl::Entity, :validator, validator) }

      it 'should return Validator instance registered in Repository' do
        expect(helper.send(:validator, Impl::Entity)).to eq(validator)
      end
    end
  end
end
