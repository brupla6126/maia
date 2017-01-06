module Araignee
  module Architecture
    # OutputBoundary receives a response and prepares it
    class OutputBoundary
      def process(_response, _context = {})
        raise NotImplementedError
      end
    end
  end
end
