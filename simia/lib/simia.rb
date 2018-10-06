require 'simia/version'

module Simia
  class << self
    def root
      @root ||= Dir.pwd
    end
  end
end
