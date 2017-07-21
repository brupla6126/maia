require 'araignee/architecture/model'

include Araignee::Architecture

RSpec.describe Araignee::Architecture::Model do
  class User < Model
    attributes :name
    attributes :age
    attributes :country
  end

  describe '#initialize' do
    let(:user) { User.new(name: 'joe', age: 20, pets: 2) }

    context 'when name is set' do
      it 'should equal joe' do
        expect(user.name).to eq('joe')
      end
    end

    context 'when age is set' do
      it 'should equal 20' do
        expect(user.age).to eq(20)
      end
    end

    context 'when pets is set' do
      it 'should equal 2' do
        expect(user.pets).to eq(2)
      end
    end

    context 'when country is not set' do
      it 'should equal nil' do
        expect(user.country).to eq(nil)
      end
    end
  end
end
