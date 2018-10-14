require 'ostruct'

require 'artemisia/version'
require 'artemisia/context'
require 'artemisia/engine'

module Artemisia
  class << self
    def root
      @root ||= Dir.pwd
    end
  end

  def self.boot
    config_params = {
      initializers_path: File.join(Artemisia.root, 'config', 'initializers'),
      factories_paths: [File.join(Artemisia.root, 'app', 'factories')],
      templates_paths: [File.join(Artemisia.root, 'app', 'templates')]
    }
    @config = OpenStruct.new(config_params)
    @context = Context.new(@config)
    @engine = Engine.new(@context)

    @engine.boot
    @engine.run
    @engine.shutdown
  end

  def self.setup(&block)
    yield @context.config if block
  end
end
