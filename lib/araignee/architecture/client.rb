require 'araignee/utils/plugin'

module Architecture
  # Class for service client
  class Client < Plugin
    def initialize(_contracts = [], adapters = [])
      super([:client], adapters)

      Log[:architecture].debug { "initialize: #{self.class}" }
    end

    # called per request
    def initiate
      Log[:architecture].info { "#{@name}::initiate()" }

      @adapters.map(&:initiate)
    end

    # called per request
    def terminate
      Log[:architecture].info { "#{@name}::terminate()" }

      @adapters.map(&:terminate)
    end
  end
end
