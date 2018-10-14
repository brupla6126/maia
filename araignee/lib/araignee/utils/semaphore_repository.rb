require 'araignee/utils/repository'

module Araignee
  module Utils
    # A Semaphore repository is a container where you can register a semaphore,
    # acquire up to a maximum count and release them.
    class SemaphoreRepository < Repository
      def initialize(repository)
        @repository = repository
      end

      def register(name, maximum = 1)
        raise ArgumentError, "Semaphore #{name} already registered" if @repository.get(name)
        raise ArgumentError, 'maximum count must be greater or equal to 1' unless maximum >= 1

        @repository.set(name, maximum: maximum, acquired: 0)
      end

      def acquire(name)
        semaphore = @repository.get(name)

        raise ArgumentError, "Semaphore #{name} not registered" unless semaphore

        return false if semaphore[:acquired] >= semaphore[:maximum]

        semaphore[:acquired] += 1

        true
      end

      def release(name)
        semaphore = @repository.get(name)

        raise ArgumentError, "Semaphore #{name} not registered" unless semaphore

        raise ArgumentError, "Semaphore #{name} already exhausted" if semaphore[:acquired] <= 0

        semaphore[:acquired] -= 1

        true
      end
    end
  end
end
