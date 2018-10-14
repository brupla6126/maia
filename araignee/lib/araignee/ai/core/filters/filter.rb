module Araignee
  # Module for gathering AI classes
  module Ai
    module Core
      # Filters are utility classes that accept and reject nodes
      module Filters
        # Default Filter class
        class Filter
          # Default behavior: accept nothing
          def accept(_nodes)
            []
          end

          # Default behavior: reject nothing
          def reject(_nodes)
            []
          end
        end
      end
    end
  end
end
