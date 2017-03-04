require 'araignee/architecture/repository'

include Araignee::Architecture

RSpec.describe Repository do
  after do
    Repository.clean
  end

  describe '#helpers' do
    context 'when no helper registered' do
      it 'should return {}' do
        expect(Repository.helpers).to eq({})
      end
    end
  end

  describe '#count' do
    context 'when no helper registered' do
      it 'should return 0' do
        expect(Repository.count).to eq(0)
      end
    end
  end

  describe '#register' do
    context 'one at a time' do
      before { Repository.register(:objects, :validator, 1) }

      it 'should have registered 1 helper' do
        expect(Repository.count).to eq(1)
      end
    end

    context 'many at once' do
      before do
        Repository.register(:objects) do |helpers|
          helpers[:finder] = 1
          helpers[:creator] = 2
        end
      end

      it 'should have registered 2 helpers' do
        expect(Repository.count).to eq(2)
      end
    end
  end

  describe '#for' do
    before { Repository.register(:objects, :validator, 1) }

    context 'when asking existing helper' do
      it 'should return it' do
        expect(Repository.for(:objects, :validator)).to eq(1)
      end
    end

    context 'when asking inexisting helper' do
      it 'should raise ArgumentError helper :actions not registered' do
        expect(Repository.for(:actions, :validator)).to eq(nil)
      end
    end
  end

  describe '#clean' do
    before do
      Repository.register(:objects, :validator, 1)
      Repository.clean
    end

    it 'should not have helpers registered' do
      expect(Repository.count).to eq(0)
    end
  end
end
