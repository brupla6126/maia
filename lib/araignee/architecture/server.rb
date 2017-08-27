require 'araignee/utils/plugin'

module Architecture
  # Class for service server
  class Server < Plugin
    attr_accessor :controllers

    def initialize(_contracts = [], adapters = [])
      super([:server], adapters)

      @controllers = {}

      Log[:architecture].debug { "initialize: #{self.class}" }
    end

    def configure(config)
      super

      if @config[:server]
        @config[:server][:controllers].each do |name, klass|
          @controllers[name] = klass.new
          @controllers[name].configure(@config)
        end
      end

      Log[:architecture].info { "Controllers: #{@controllers.keys}" }
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
