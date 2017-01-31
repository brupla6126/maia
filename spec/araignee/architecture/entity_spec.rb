require 'araignee/architecture/entity'

include Araignee::Architecture

class User < Entity
  attribute :name, String, default: 'black'
  attribute :age, Integer, default: 0
end

RSpec.describe Araignee::Architecture::Entity do
  describe '#initialize' do
    let(:user) { User.new(name: 'joe') }

    context 'when name not set' do
      let(:user_empty) { User.new }
      it 'should default to black' do
        expect(user_empty.name).to eq('black')
      end
    end
    context 'when name set' do
      it 'should equal joe' do
        expect(user.name).to eq('joe')
      end
    end
    context 'when age not set' do
      it 'should default to 0' do
        expect(user.age).to eq(0)
      end
    end
  end
end
