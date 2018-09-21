module Artemisia
  class World
    attr_reader :id, :managers, :systems

    def initialize(id)
      @id = id
      @managers = {}
      @systems = {}
    end

    def manager(type)
      @managers[type]
    end

    def system(type)
      @systems[type]
    end

    def self.setup(&block)
      instance_eval(&block)
    end

    def self.subscribe(&block)
      instance_eval(&block)
    end
  end
end
