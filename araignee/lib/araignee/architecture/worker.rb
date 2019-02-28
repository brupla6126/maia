require 'hashie'
require 'ostruct'

class Worker
  def process(workload, delivery_info: nil, metadata: nil)
    Hashie.symbolize_keys!(workload)

    request = OpenStruct.new(workload)

    logger.info { "request: #{request.inspect}" }

    # entity_gateway
    # input_boundary
    # output_boundary

    validate(request)

    attributes = request.to_h.select { |k| %i[operation trace].include?(k) }

    # board is used to pass data from one handler to another
    board = {}
    response = OpenStruct.new(attributes)

    handle(request, response, board)

    logger.info { "board: #{board}" }

    logger.info { "response: #{response.inspect}" }
  end

  def validate(request)
    validators.each { |validator| validator.validate(request) }
  end

  def handle(request, response, board)
    handlers.each { |handler| handler.handle(request, response, board) }
  end

  # must be implemented in derived classes
  def logger; end

  def validators; end

  def handlers; end

  private

  def handle_error(error, workload)
    logger.error { "workload: #{workload}" }
    logger.error { "error: #{error.message}" }
    logger.error { "trace: #{error.backtrace}" }
  end
end
