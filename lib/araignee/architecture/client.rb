require 'araignee/utils/plugin'

include Araignee::Utils

module Araignee
  module Architecture
    # Class for service client
    class Client < Plugin
      def initialize(_contracts = [], adapters = [])
        super([:client], adapters)

        Log[@name].debug { "initialize: #{self.class}" }
      end

      # called per request
      def initiate
        Log[@name].info { "#{@name}::initiate()" }

        @adapters.map(&:initiate)
      end

      # called per request
      def terminate
        Log[@name].info { "#{@name}::terminate()" }

        @adapters.map(&:terminate)
      end
    end
  end
end
