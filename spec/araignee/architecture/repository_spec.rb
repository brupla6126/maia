require 'araignee/architecture/repository'

include Araignee::Architecture

module Repositories
  module Objects
    class Memory
    end
  end
end

RSpec.describe Repository do
  let(:objects_memory) { Repositories::Objects::Memory.new }
  after do
    Repository.clean
  end

  describe '#repositories' do
    context 'when no repository registered' do
      it 'size should return 0' do
        expect(Repository.repositories.size).to eq(0)
      end
    end
  end

  describe '#register' do
    before { Repository.register(:objects, objects_memory) }

    context 'when registering 1 repository' do
      it 'should have registered 1 repository' do
        expect(Repository.repositories.size).to eq(1)
      end
    end
  end

  describe '#for' do
    before { Repository.register(:objects, objects_memory) }

    context 'when asking existing repository' do
      it 'should return it' do
        expect(Repository.for(:objects)).not_to eq(nil)
      end
    end

    context 'when asking inexisting repository' do
      it 'should raise ArgumentError repository :actions not registered' do
        expect(Repository.for(:actions)).to eq(nil)
      end
    end
  end

  describe '#clean' do
    before do
      Repository.register(:objects, objects_memory)
      Repository.clean
    end
    it 'should not have repositories registered' do
      expect(Repository.repositories.empty?).to eq(true)
    end
  end
end
