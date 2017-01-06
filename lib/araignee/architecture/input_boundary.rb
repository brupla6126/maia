module Araignee
  module Architecture
    # InputBoundary receives a request and a context, processes the request and send it to an output boundary
    class InputBoundary
      def process(_request, _output_boundary, _context = {})
        raise NotImplementedError
      end
    end
  end
end
