require 'gamia/version'

module Gamia
  class << self
    def root
      @root ||= Dir.pwd
    end
  end
end
