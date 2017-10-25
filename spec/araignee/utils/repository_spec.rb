require 'timecop'
require 'araignee/utils/repository'

RSpec.describe Repository do
  let(:repository) { Repository.new }

  let(:key) { 'abc' }
  let(:value) { 123 }
  let(:default) { nil }
  let(:expiration) { Time.now + 3 }

  describe '#get' do
    subject { repository.get(key, default) }

    context 'valid key' do
      before { repository.set(key, value) }

      it 'returns the value' do
        expect(subject).to eq(value)
      end
    end

    context 'invalid key' do
      let(:key) { nil }

      it 'returns nil' do
        expect(subject).to eq(nil)
      end
    end

    context 'unknown key' do
      context 'without default value' do
        it 'returns nil' do
          expect(subject).to eq(nil)
        end
      end

      context 'with default value' do
        let(:default) { 3 }

        it 'returns default value' do
          expect(subject).to eq(default)
        end
      end
    end

    context 'expired key' do
      before { repository.set(key, value, expiration) }

      it 'returns nil' do
        Timecop.travel(Time.now + 5)

        expect(subject).to eq(nil)

        Timecop.return
      end
    end
  end

  describe '#set' do
    subject { repository.set(key, value, expiration) }

    it 'has set value and expiration' do
      Timecop.travel(Time.now - 5)

      subject
      expect(repository.get(key)).to eq(value)

      Timecop.return
    end
  end

  describe '#delete' do
    subject { repository.delete(key) }

    context 'valid key' do
      before { repository.set(key, value) }

      it 'returns the value' do
        expect(subject).to eq(value)
      end
    end

    context 'invalid key' do
      it 'returns nil' do
        expect(subject).to eq(nil)
      end
    end
  end

  describe '#expire' do
    subject { repository.send(:expire) }

    before do
      repository.set('abc', 1, 2)
      repository.set('def', 2)
    end

    it 'removed expired keys' do
      Timecop.travel(Time.now + 5)

      expect(subject.count).to eq(1)
      expect(repository.get('def')).to eq(2)

      Timecop.return
    end
  end

  describe '#clear' do
    subject { repository.clear }

    before do
      repository.set('abc', 1)
      repository.set('def', 2)
    end

    it 'is empty' do
      expect(subject.count).to eq(0)
      expect(subject.empty?).to eq(true)
    end
  end
end
