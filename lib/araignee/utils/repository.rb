require 'forwardable'

# A Repository is simply a container that we can put/get/delete
# stuff using a key that may expire.
module Repository
  extend Forwardable

  def_delegators :@storage, :clear, :empty?, :count

  def get(key)
    delete(key) if expired?(key)

    @storage[key] ? @storage[key][:value] : nil
  end

  def set(key, value, expiration = nil)
    @storage[key] ||= {}
    @storage[key][:value] = value
    @storage[key][:expiration] = expiration
  end

  def delete(key)
    data = @storage.delete(key)
    data[:value] if data
  end

  private

  def expired?(key)
    @storage[key] && @storage[key][:expiration] && @storage[key][:expiration] < Time.now
  end
end

class RepositoryInstance
  include Repository

  def initialize(storage)
    @storage = storage
  end
end

class RepositoryStatic
  extend Repository

  class << self
    attr_accessor :storage
  end
end
