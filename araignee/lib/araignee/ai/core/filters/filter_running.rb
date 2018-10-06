require 'araignee/ai/core/filters/filter'

# Module for gathering AI classes
module Ai
  module Core
    # Filters are utility classes that accept and reject nodes
    module Filters
      # Filter to select running nodes
      class FilterRunning < Filter
        def accept(nodes)
          nodes.select(&:running?)
        end
      end
    end
  end
end
