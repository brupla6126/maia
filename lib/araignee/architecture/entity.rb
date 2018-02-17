module Architecture
  class Entity
    def initialize(attributes)
      defaults.merge(attributes).each do |key, value|
        instance_variable_set(:"@#{key}", value)

        self.class.__send__(:attr_accessor, key)
      end
    end

    private

    def defaults
      {}
    end
  end
end
