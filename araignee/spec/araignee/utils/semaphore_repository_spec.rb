require 'timecop'
require 'araignee/utils/repository'
require 'araignee/utils/semaphore_repository'

RSpec.describe SemaphoreRepository do
  let(:repository) { Repository.new }
  let(:semaphores) { SemaphoreRepository.new(repository) }

  let(:semaphore) { 'abc' }
  let(:maximum) { 3 }

  describe '#register' do
    subject { semaphores.register(semaphore) }

    context 'already registered semaphore' do
      before { semaphores.register(semaphore) }

      it 'raises ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, "Semaphore #{semaphore} already registered")
      end
    end

    context 'with invalid maximum' do
      subject { semaphores.register(semaphore, 0) }

      it 'raises ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, 'maximum count must be greater or equal to 1')
      end
    end

    context 'without maximum' do
      subject { semaphores.register(semaphore) }

      it 'returns nil' do
        expect(subject).to eq(true)
      end
    end

    context 'calls #set' do
      subject { semaphores.register(semaphore, maximum) }

      before { allow(repository).to receive(:set) }

      it 'returns nil' do
        expect(repository).to receive(:set).with(semaphore, maximum: maximum, acquired: 0)
        subject
      end
    end
  end

  describe '#acquire' do
    subject { semaphores.acquire(semaphore) }

    context 'semaphore is not registered' do
      let(:semaphore) { 'abcdef' }

      it 'raises ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, "Semaphore #{semaphore} not registered")
      end
    end

    context 'semaphore is registered' do
      before { semaphores.register(semaphore) }

      context 'no semaphore left' do
        before { semaphores.acquire(semaphore) }

        it 'returns false' do
          expect(subject).to eq(false)
        end
      end

      context 'with semaphore left' do
        it 'returns true' do
          expect(subject).to eq(true)
        end
      end
    end
  end

  describe '#release' do
    subject { semaphores.release(semaphore) }

    context 'semaphore is not registered' do
      let(:semaphore) { 'abcdef' }

      it 'raises ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, "Semaphore #{semaphore} not registered")
      end
    end

    context 'semaphore is registered' do
      before { semaphores.register(semaphore) }

      context 'no semaphore left to release' do
        it 'raises ArgumentError' do
          expect { subject }.to raise_error(ArgumentError, "Semaphore #{semaphore} already exhausted")
        end
      end

      context 'with acquired semaphore' do
        before { semaphores.acquire(semaphore) }

        it 'returns true' do
          expect(subject).to eq(true)
        end
      end
    end
  end
end
