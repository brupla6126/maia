require 'timecop'
require 'araignee/utils/repository'

RSpec.describe RepositoryInstance do
  let(:storage) { {} }
  let(:repository) { RepositoryInstance.new(storage) }

  let(:key) { 'abc' }
  let(:value) { 123 }
  let(:expiration) { Time.now + 3 }

  describe '#get' do
    subject { repository.get(key) }

    context 'valid key' do
      before { storage[key] = { value: value } }

      it 'should return the value' do
        expect(subject).to eq(value)
      end
    end

    context 'invalid key' do
      let(:key) { nil }

      it 'should return nil' do
        expect(subject).to eq(nil)
      end
    end

    context 'unknown key' do
      it 'should return nil' do
        expect(subject).to eq(nil)
      end
    end

    context 'expired key' do
      before { storage[key] = { value: value, expiration: expiration } }

      it 'should return nil' do
        Timecop.travel(Time.now + 5)

        expect(subject).to eq(nil)

        Timecop.return
      end
    end
  end

  describe '#set' do
    it 'should have set value and expiration' do
      repository.set(key, value, expiration)

      expect(storage[key][:value]).to eq(value)
      expect(storage[key][:expiration]).to eq(expiration)
    end
  end

  describe '#delete' do
    subject { repository.delete(key) }

    context 'valid key' do
      before { storage[key] = { value: value } }

      it 'should return the value' do
        expect(subject).to eq(value)
      end
    end

    context 'invalid key' do
      it 'should return nil' do
        expect(subject).to eq(nil)
      end
    end
  end

  describe '#clear' do
    before do
      repository.set('abc', 1)
      repository.set('def', 2)
    end

    subject { repository.clear }

    it 'should be empty' do
      expect(subject.count).to eq(0)
      expect(subject.empty?).to eq(true)
    end
  end
end

RSpec.describe RepositoryStatic do
  let(:storage) { {} }
  let(:repository) { RepositoryStatic }

  let(:key) { 'abc' }
  let(:value) { 123 }
  let(:expiration) { Time.now + 3 }

  before { RepositoryStatic.storage = storage }

  describe '#get' do
    subject { repository.get(key) }

    context 'valid key' do
      before { storage[key] = { value: value } }

      it 'should return the value' do
        expect(subject).to eq(value)
      end
    end

    context 'invalid key' do
      let(:key) { nil }

      it 'should return nil' do
        expect(subject).to eq(nil)
      end
    end

    context 'unknown key' do
      it 'should return nil' do
        expect(subject).to eq(nil)
      end
    end

    context 'expired key' do
      before { storage[key] = { value: value, expiration: expiration } }

      it 'should return nil' do
        Timecop.travel(Time.now + 5)

        expect(subject).to eq(nil)

        Timecop.return
      end
    end
  end

  describe '#set' do
    it 'should have set value and expiration' do
      repository.set(key, value, expiration)

      expect(storage[key][:value]).to eq(value)
      expect(storage[key][:expiration]).to eq(expiration)
    end
  end

  describe '#delete' do
    subject { repository.delete(key) }

    context 'valid key' do
      before { storage[key] = { value: value } }

      it 'should return the value' do
        expect(subject).to eq(value)
      end
    end

    context 'invalid key' do
      it 'should return nil' do
        expect(subject).to eq(nil)
      end
    end
  end

  describe '#clear' do
    before do
      repository.set('abc', 1)
      repository.set('def', 2)
    end

    subject { repository.clear }

    it 'should be empty' do
      expect(subject.count).to eq(0)
      expect(subject.empty?).to eq(true)
    end
  end
end
