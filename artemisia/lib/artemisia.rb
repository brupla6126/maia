require 'ostruct'

require 'artemisia/version'
require 'artemisia/engine'

module Artemisia
  class << self
    def root
      @root ||= Dir.pwd
    end
  end

  def self.boot
    config_params = {
      initializer_paths: [File.join(Artemisia.root, 'config', 'initializers')],
      factory_paths: [File.join(Artemisia.root, 'app', 'factories')],
      template_paths: [File.join(Artemisia.root, 'app', 'templates')]
    }
    @config = OpenStruct.new(config_params)
    @context = OpenStruct.new
    @engine = Engine.new(config: @config, context: @context)

    @engine.boot
    @engine.run
    @engine.shutdown
  end

  def self.setup(&block)
    yield @config, @context if block
  end
end
