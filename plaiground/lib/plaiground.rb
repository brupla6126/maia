require 'plaiground/version'

module Plaiground
  class << self
    def root
      @root ||= Dir.pwd
    end
  end
end
