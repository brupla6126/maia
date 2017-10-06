require 'araignee/ai/node'

# Module for gathering AI classes
module AI
  # An Assertion Node will evaluate a condition and
  # its response can only be :succeeded or :failed
  # Derived classed will implement the assertion test
  class Assertion < Node
    def execute(entity, world)
      response = assert(entity, world)

      update_response(handle_response(response))
    end

    protected

    def assert(_entity, _world)
      raise NotImplementedError
    end

    private

    def handle_response(response)
      # only accept :succeeded and :failed

      return :failed unless response.equal?(:succeeded)

      :succeeded
    end
  end
end
