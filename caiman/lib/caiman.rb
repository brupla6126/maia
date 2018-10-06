require 'caiman/version'

module Caiman
  class << self
    def root
      @root ||= Dir.pwd
    end
  end
end
