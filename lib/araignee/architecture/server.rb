require 'araignee/utils/plugin'

include Araignee::Utils

module Araignee
  module Architecture
    # Class for service server
    class Server < Plugin
      attr_accessor :controllers

      def initialize(_contracts = [], adapters = [])
        super([:server], adapters)

        @controllers = {}

        Log[@name].debug { "initialize: #{self.class}" }
      end

      def configure(config)
        super

        if @config[:server]
          @config[:server][:controllers].each do |name, klass|
            @controllers[name] = klass.new
            @controllers[name].configure(@config)
          end
        end

        Log[@name].info { "Controllers: #{@controllers.keys}" }
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

      def serve
      end

      def operation_supported?(object, action)
        @controllers.key?(object) && @controllers[object].respond_to?(action)
      end

      def execute(object, action, request)
        @controllers[object].send(action, request)
      end
    end
  end
end
