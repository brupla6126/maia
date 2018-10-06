require 'artemisia/emitter'

module Artemisia
  class Clock
    include Emitter

    def initialize(frequency)
      @frequency = frequency
      @last = Time.now

      # start thread
    end

    def process
      elapsed = Time.now - @last

      emit(:tick, elapsed)
    end
  end
end
