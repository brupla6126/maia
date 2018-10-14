require 'forwardable'

module Araignee
  module Utils
    # A Repository is simply a container that we can put/get/delete
    # stuff using a key that may expire.
    class Repository
      extend Forwardable

      def_delegators :@storage, :clear, :empty?, :count

      def initialize
        @storage = {}
      end

      def get(key, default = nil)
        expire

        @storage.key?(key) ? @storage.fetch(key).fetch(:value) : default
      end

      def set(key, value, expiration = nil)
        @storage[key] ||= {}
        @storage[key][:value] = value
        @storage[key][:expiration] = expiration if expiration

        true
      end

      def delete(key)
        data = @storage.delete(key)

        data&.fetch(:value)
      end

      private

      def expire
        @storage.delete_if do |_key, value|
          value[:expiration] && value[:expiration].to_i < Time.now.to_i
        end
      end
    end
  end
end
