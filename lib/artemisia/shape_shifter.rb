module ShapeShifter
  @registry = {}
  @classes = {}

  def self.registry
    @registry
  end

  def self.classes
    @classes
  end

  def self.define(&block)
    definition_proxy = DefinitionProxy.new
    definition_proxy.instance_eval(&block)
  end

  def self.build(id, overrides = {})
    klass = classes[id]
    instance = klass.new
    factory = registry[id]

    attributes = factory.attribs.merge(overrides)
    attributes['id'] = id.to_s
    attributes['definition'] = klass.to_s
    attributes.each do |attribute_name, value|
      instance.send("#{attribute_name}=", value)
    end

    instance
  end
end

class DefinitionProxy
  def factory(id, klass, &block)
    factory = Factory.new
    factory.instance_eval(&block)

    ShapeShifter.registry[id] = factory
    ShapeShifter.classes[id] = klass
  end
end

class Factory < BasicObject
  def initialize
    @attribs = {}
  end

  attr_reader :attribs

  def method_missing(name, *args, &block)
    @attribs[name] = args[0] if args[0]

    yield if block
  end
end
