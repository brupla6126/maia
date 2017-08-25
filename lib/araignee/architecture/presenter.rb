module Architecture
  # Presenter component part of MVP.
  # It receives a data model and delivers prepared(format, translate, localize) data
  # as the response model.
  class Presenter
    def process(data_model, response_model, context = nil)
      present(data_model, response_model, context)
    end

    private

    # Derived class can process the response model and
    # prepare(format, translate, localize, ...) data into a view model
    def present(_data_model, _response_model, _context)
      raise NotImplementedError
    end
  end
end
