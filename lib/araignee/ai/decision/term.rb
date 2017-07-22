#!/usr/bin/env ruby
# encoding: utf-8

require 'araignee/ai/node'

# Module Araignee
module Araignee
  # Module for gathering AI classes
  module AI
    # Module for gathering Decision Tree classes
    module Decision
      # Class Term, base class for all Terms
      class Term < Node
        def truth?(_entity, _world)
          raise NotImplementedError
        end
      end
    end
  end
end
