module Araignee
  class << self
    def root
      @root ||= Dir.pwd
    end
  end
end
